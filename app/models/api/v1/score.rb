module Api
  module V1
    # Manages team scores
    class Score < ApplicationRecord
      belongs_to :team
      belongs_to :round

      validates_uniqueness_of :round_id, scope: :team_id, message: 'Score ja cadastrado'

      # Create the scores for the round, as soon as market closes
      # same conditions to create battles
      def self.create_scores
        create_scores_rounds.each do |round|
          create_scores_round(round)
        end
        true
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.create_scores_rounds
        Round.avaliable_for_score_generation
      end

      def self.create_scores_round(round)
        round.round_control.update_attributes(creating_scores: true)
        Team.active.each do |team|
          Score.create(team: team, round: round,
                       team_name: team.name,
                       player_name: team.player_name)
        end
        round.round_control.update_attributes(scores_created: true)
        true
      end

      # Rules:
      # finished
      # scores created
      # scores not updated
      def self.rounds_with_scores_to_update
        Round.rounds_with_scores_to_update
      end

      def self.update_scores_round(round)
        round.round_control.update_attributes(updating_scores: true)
        Team.active.each do |team|
          update_team_scores(round, team)
        end
        round.round_control.update_attributes(scores_updated: true)
        true
      end

      def self.update_team_scores(round, team)
        api_scores = Connection.team_score(team.slug, round.number)
        raise 'Invalid API Scores' if api_scores.nil? || !api_scores.include?('pontos')

        score = Score.find_by(round: round, team: team)
        raise 'Score não encontrado' if score.nil?

        score.update_attributes(final_score: api_scores['pontos'].round(2))
      end

      def self.update_scores
        rounds_with_scores_to_update.each do |round|
          update_scores_round(round)
        end
        true
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.team_details(team, scores)
        details = []
        team_scores = scores.where(team: team).order(:round_id)
        team_scores.each do |ts|
          details << { round: ts.round.number, points: ts.final_score }
        end
        details
      end

      def self.dispute_months_players(scores, teams)
        players = []
        teams.each do |team|
          player = { name: team.player_name, team: team.name,
                     team_symbol: team.url_escudo_png }
          player[:details] = team_details(team, scores)
          player[:points] = player[:details].pluck(:points).sum
          players << player
        end
        players
      end

      def self.order_dispute_months(array)
        array.sort_by { |hash| hash[:id] }.reverse!
      end

      # Builds a hash with all team scores with details
      # grouped by dispute month
      def self.show_scores
        teams = Team.active
        months = []
        Season.active.dispute_months.each do |dm|
          dispute_month = { name: dm.name, id: dm.id }
          dispute_month[:players] = dispute_months_players(dm.scores, teams)
          months << dispute_month
        end
        result = order_dispute_months(months)
        $redis.set('scores', result.to_json)
        result
      end
    end
  end
end

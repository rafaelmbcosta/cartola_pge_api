module Api
  module V1
    class FinalScore
      def self.perform(round, maintenance = false)
        to_verify = maintenance ? JSON.parse($redis.get("to_fix_#{round.id}")) : []
        previous_round = Round.find{ |r| r.season == round.season and r.number == round.number - 1 } if round.number > 1
        market_status = Connection.market_status
        teams = Team.where(season: round.season, active: true)
        teams.each do |team|
          pontuacao = Connection.team_score(team.slug, round.number)
          points = pontuacao["pontos"] || 0
          score = Score.find{|sc| sc.team_id == team.id and sc.round_id == round.id }
          if score.nil?
            score = Score.create(team: team, round: round,
                final_score: points.round(2), team_name: team.name,
                player_name: team.player.name)
          else
            score.update_attributes(final_score: points.round(2))
            previous_points = Score.find{ |sc| sc.team_id == team.id and sc.round_id == previous_round.id }.final_score if round.number > 1
            to_verify << score.id if score.final_score == previous_points
            to_verify.delete(score.id) if maintenance and score.final_score != previous_points and to_verify.include?(score.id)
          end
        end
        $redis.set("to_fix_#{round.id}", to_verify.to_json)
        BattleResults.perform(round)
      end
    end
  end
end

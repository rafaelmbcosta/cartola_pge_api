# Generate team battles every round
class Battle < ApplicationRecord
  include Concern::Battle::ShowLeague
  include Concern::Battle::Sync
  include Concern::Battle::Creation
  include Concern::Battle::ShowBattles
  include Concern::Battle::UpdateBattles

  belongs_to :round

  scope :find_battle, lambda { |round, team, other_team|
    where(round: round).where('first_id = ? and second_id = ?', team, other_team)
  }

  def self.rounds_avaliable_for_battles
    Round.avaliable_for_battles
  end

  def first_victory(team_id)
    first_id == team_id && first_win
  end

  def second_victory(team_id)
    second_id == team_id && second_win
  end

  def team_victory(team)
    first_victory(team.id) || second_victory(team.id)
  end

  def team_difference_points
    (first_points - second_points).abs
  end

  def self.list_battles
    $redis.get('battles')
  end

  def self.rerun_battles(this_dispute_month = false)
    rounds = Round.season_finished_rounds(this_dispute_month)
    rounds.each do |round|
      update_battle_scores_round(round)
    end
  end


end

# class MonthlyAwardReport
#   def self.format_winner(winner)
#     hash = {
#       :team_name => winner.team.name,
#       :position => winner.position,
#       :prize => winner.prize,
#       :team_symbol => winner.team.url_escudo_png
#     }
#     return hash
#   end

#   def self.perform
#     champions = Array.new
#     season = Season.last
#     awards = Award.where("season_id = ? and award_type in (1, 2, 5, 6)", season.id).group_by{|aw| aw.dispute_month}
#     report = []
#     awards.each do |dispute_month, award_list|
#       dispute = Hash.new
#       dispute["name"] = dispute_month.name
#       dispute["id"] = dispute_month.id
#       dispute["awards"] = []
#       award_list.group_by{|list| "#{list.award_type}#{" " + list.round.number.to_s unless list.round.nil?}"}.each do |type, winners|
#         award = Hash.new
#         award["type"] = type
#         award["winners"] = []
#         winners.each do |winner|
#           award["winners"] << format_winner(winner)
#         end
#         dispute["awards"] << award
#       end
#       report << dispute
#       report.sort_by!{|aw| aw["id"]}
#     end
#     $redis.set("monthly_awards", report.reverse.to_json)
#   end
# end

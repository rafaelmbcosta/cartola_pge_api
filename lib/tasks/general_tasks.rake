desc "This task is called by the Heroku scheduler add-on"
task :general_tasks => :environment do
  Round.general_tasks_routine
end

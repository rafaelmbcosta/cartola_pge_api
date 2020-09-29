desc "Setup database to match production"


task :sync_db => :environment do
  if ['development', 'test'].include?(Rails.env)
    require 'open-uri'
    require 'database_cleaner'

    puts 'reseting database...'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    puts 'creating season...'
    Api::V1::Season.sync
    puts 'getting teams...'
    Api::V1::Team.sync
    puts 'gettin dispute months...'
    Api::V1::DisputeMonth.sync
    puts "creating rounds..."
    Api::V1::Round.sync
    puts "getting scores..."
    Api::V1::Scores.sync
    puts "gettting battles..."
    Api::V1::Battles.sync
    puts "... done!"
  end
end

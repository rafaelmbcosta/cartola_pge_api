FactoryBot.define do
  factory :v1_season, class: Api::V1::Season do
    finished { false }
  end
end

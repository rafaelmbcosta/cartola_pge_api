FactoryBot.define do
  factory :dispute_month, class: DisputeMonth do
    name { Date::MONTHNAMES[rand(1..11)] }
  end
end

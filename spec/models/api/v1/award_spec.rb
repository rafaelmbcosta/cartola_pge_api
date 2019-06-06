require 'rails_helper'

module Api
  module V1
    RSpec.describe Award, type: :model do
      describe "Relationship" do
        it { should belong_to :dispute_month }
        it { should belong_to :team }
        it { should belong_to :season }
      end
    end
  end
end

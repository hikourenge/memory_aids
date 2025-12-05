class CardSession < ApplicationRecord
    belongs_to :play_session
    belongs_to :card

  #    validates :is_correct, inclusion: { in: [true, false] }
end

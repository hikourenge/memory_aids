class Hint < ApplicationRecord
    validates :content, presence: true, length: { maximum: 500 }
    validates :hint_position, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :card_id }

    belongs_to :card

    validate :hints_count_within_limit, on: :create

    private

    MAX_HINTS_PER_CARD = 3

    def hints_count_within_limit
        return unless card

        if card.hints.count >= MAX_HINTS_PER_CARD
        errors.add(:base, "ヒントは1枚のカードにつき最大#{MAX_HINTS_PER_CARD}件までです")
        end
    end
end

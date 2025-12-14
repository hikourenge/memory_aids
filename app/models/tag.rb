class Tag < ApplicationRecord
    has_many :decks_tags, dependent: :destroy
    has_many :decks, through: :decks_tags
    validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
end

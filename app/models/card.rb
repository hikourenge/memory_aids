class Card < ApplicationRecord
    validates :question, presence: true, length: { maximum: 500 }
    validates :answer, presence: true, length: { maximum: 500 }
    validates :position, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :deck_id }

    belongs_to :user
    belongs_to :deck

    has_many :hints, dependent: :destroy

    mount_uploader :card_image, CardImageUploader
end

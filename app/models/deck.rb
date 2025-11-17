class Deck < ApplicationRecord
    validates :title, presence: true, length: { maximum: 63 }
    validates :description, presence: true, length: { maximum: 255 }

    enum :status, { hidden: 0, published: 1 }, prefix: true

    mount_uploader :deck_image, DeckImageUploader

    belongs_to :user
end

class Deck < ApplicationRecord
    validates :title, presence: true, length: { maximum: 63 }
    validates :description, presence: true, length: { maximum: 255 }

    enum :status, { hidden: 0, published: 1 }, prefix: true

    belongs_to :user
end

class Deck < ApplicationRecord
    validates :title, presence: true, length: { maximum: 63 }
    validates :description, presence: true, length: { maximum: 255 }

    enum :status, { hidden: 0, published: 1 }, prefix: true

    mount_uploader :deck_image, DeckImageUploader

    belongs_to :user
    has_many :cards, dependent: :destroy
    has_many :play_sessions, dependent: :destroy

    def self.ransackable_attributes(auth_object = nil)
        %w[title]
    end

    def self.ransackable_associations(auth_object = nil)
        []
    end

    def self.ransortable_attributes(auth_object = nil)
        []
    end

    def self.ransackable_scopes(auth_object = nil)
        []
    end
end

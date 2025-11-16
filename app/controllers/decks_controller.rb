class DecksController < ApplicationController
    before_action :authenticate_user!, only: [ :my_decks ]

    def index
        @decks = Deck.status_published.includes(:user).order(created_at: :desc)
      end

    def my_decks
        @decks = current_user.decks.includes(:user).order(created_at: :desc)
    end
end

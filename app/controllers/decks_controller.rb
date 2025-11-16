class DecksController < ApplicationController
    before_action :authenticate_user!, only: [ :my_decks, :new ]

    def index
        @decks = Deck.status_published.includes(:user).order(created_at: :desc)
      end

    def my_decks
        @decks = current_user.decks.includes(:user).order(created_at: :desc)
    end

    def new
        @deck = Deck.new
    end

    def create
        @deck = current_user.decks.build(deck_params)
        if @deck.save
          redirect_to my_decks_decks_path, notice: t('decks.create.notice')
        else
          flash.now[:alert] = t('decks.create.alert') 
          render :new, status: :unprocessable_entity
        end
      end

    private
    
    def deck_params
        params.require(:deck).permit(:title, :description, :status)
      end

end

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

    def show
        @deck = Deck.find(params[:id])
        @cards = @deck.cards.includes(:user).order(position: :asc).limit(3)
      end

      def edit
        @deck = current_user.decks.find(params[:id])
      end

      def update
        @deck = current_user.decks.find(params[:id])
        if @deck.update(deck_params)
          redirect_to deck_path(@deck), notice: t("decks.update.notice")
        else
          flash.now[:alert] = t("decks.update.alert")
          render :edit, status: :unprocessable_entity
        end
      end

    def create
        @deck = current_user.decks.build(deck_params)
        if @deck.save
          redirect_to deck_path(@deck), notice: t("decks.create.notice")
        else
          flash.now[:alert] = t("decks.create.alert")
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        deck = current_user.decks.find(params[:id])
        deck.destroy!
        redirect_to my_decks_decks_path, notice: t("decks.delete.notice"), status: :see_other
      end

    private

    def deck_params
        params.require(:deck).permit(:title, :description, :status, :deck_image, :deck_image_cache)
    end
end

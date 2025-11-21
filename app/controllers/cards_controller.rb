class CardsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create edit update destroy]
    before_action :set_deck, only: %i[ new create edit update destroy ]
    before_action :set_card_for_owner, only: %i[edit update destroy]

    def index
        @deck = Deck.find(params[:deck_id])
        @cards = @deck.cards.includes(:user)
    end

    def new
        @card = @deck.cards.build
        @card.user = current_user
    end


    def create
        @card = @deck.cards.build(card_params)
        @card.user = current_user
        if @card.save
          redirect_to deck_cards_path(@deck), notice: t("cards.create.notice")
        else
          flash.now[:alert] = t("cards.create.alert")
          render :new, status: :unprocessable_entity
        end
      end

      def show
        @deck = Deck.find(params[:deck_id])
        @card = @deck.cards.find(params[:id])
      end

      def edit
      end

      def update
        @card = current_user.cards.find(params[:id])
        if @card.update(card_params)
          redirect_to deck_card_path(@deck, @card), notice: t("cards.update.notice")
        else
          flash.now[:alert] = t("cards.update.alert")
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        card = @deck.cards.find(params[:id])
        card.destroy!
        redirect_to deck_cards_path(@deck), notice: t("cards.delete.notice"), status: :see_other
      end

      private


  def set_deck
    @deck = current_user.decks.find(params[:deck_id])
  end

      def card_params
        params.require(:card).permit(:question, :answer, :position,)
      end

      def set_card_for_owner
        @card = @deck.cards.find(params[:id])
      end
end

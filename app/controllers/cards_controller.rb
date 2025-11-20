class CardsController < ApplicationController
    before_action :set_deck

    def index
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
          redirect_to deck_path(@deck), notice: t("cards.create.notice")
        else
          flash.now[:alert] = t("cards.create.alert")
          render :new, status: :unprocessable_entity
        end
      end

      def show
        @card = card.find(params[:id])
      end

      def edit
        @card = current_user.cards.find(params[:id])
      end

      def update
        @card = current_user.cards.find(params[:id])
        if @card.update(card_params)
          redirect_to card_path(@card), notice: t("cards.update.notice")
        else
          flash.now[:alert] = t("cards.update.alert")
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        card = @deck.cards.find(params[:id])
        card.destroy!
        redirect_to deck_path(@deck), notice: t("cards.delete.notice"), status: :see_other
      end

      private


  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

      def card_params
        params.require(:card).permit(:question, :answer, :position,)
      end
end

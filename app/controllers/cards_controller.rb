class CardsController < ApplicationController
    before_action :set_deck, only: [:new, :create]

    def index
        @cards = current_user.cards.includes(:user)
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

      private


  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

      def card_params
        params.require(:card).permit(:question, :answer, :position,)
      end

end
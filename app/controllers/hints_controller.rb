class HintsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_deck_and_card, only: %i[ new create edit destroy close update ]

    def new
        @hint = Hint.new
      end

      def create
        @hint = @card.hints.build(hint_params)
        @hint.hint_position ||= @card.hints.maximum(:hint_position).to_i + 1

        respond_to do |format|
          if @hint.save
            flash.now[:notice] = t("hints.create.notice")
            format.turbo_stream
            format.html { redirect_to deck_card_path(@deck, @card), notice: t("hints.create.notice") }

          else
            # フォームだけ差し替えてエラー表示
            flash.now[:alert] = t("hints.create.alert")
            format.turbo_stream do
              render turbo_stream: [
              turbo_stream.update("flash", partial: "shared/flash_message"),
              turbo_stream.update("hint_form", partial: "hints/form", locals: { hint: @hint, card: @card })
            ]
            end
            format.html { render "cards/show", status: :unprocessable_entity }
          end
        end
      end

      def edit
        @hint = @card.hints.find(params[:id])
      end


      def update
        @hint = @card.hints.find(params[:id])

        respond_to do |format|
            if @hint.update(hint_params)
              flash.now[:notice] = t("hints.update.notice")
              format.turbo_stream
              format.html do
                redirect_to deck_card_path(@deck, @card),
                            notice: t("hints.update.notice")
                end
            else
              # バリデーションエラー時の Turbo（フォームだけ差し替え）
              format.turbo_stream do
                flash.now[:alert] = t("hints.update.alert")
                render turbo_stream: [
                  turbo_stream.update("flash", partial: "shared/flash_message"),
                  turbo_stream.update("hint_form", partial: "hints/form", locals: { hint: @hint, card: @card })
                ]
                end
              format.html do
                flash.now[:alert] = t("hints.update.alert")
                render :edit, status: :unprocessable_entity
                end
            end
        end
      end

      def destroy
        @hint = @card.hints.find(params[:id])
        @hint.destroy!

        respond_to do |format|
          flash.now[:notice] = t("hints.delete.notice")
            format.turbo_stream
            format.html { redirect_to deck_card_path(@deck, @card), notice: t("hints.delete.notice") }
          end
      end

      def close
        # 何もしない（close.html.erb を描画）
      end

      private

      def set_deck_and_card
        @deck = current_user.decks.find(params[:deck_id])
        @card = @deck.cards.find(params[:card_id])
      end

    def hint_params
      params.require(:hint).permit(:content, :hint_position)
    end
end

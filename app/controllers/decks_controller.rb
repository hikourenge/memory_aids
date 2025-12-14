class DecksController < ApplicationController
    before_action :authenticate_user!, only: [ :my_decks, :new ]

    def index
        @q = Deck.ransack(params[:q])
        @decks = @q.result.status_published.includes(:user).order(created_at: :desc).page(params[:page])
      end

    def my_decks
        @q = current_user.decks.ransack(params[:q])
        @decks = @q.result.includes(:user, :tags).order(created_at: :desc)
        if params[:tag_keyword].present?
          @tag_keyword = params[:tag_keyword].strip
          @decks = @decks.joins(:tags).where("tags.name LIKE ?", "%#{@tag_keyword}%").distinct
        end

        @decks = @decks.page(params[:page])
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
        @tags = @deck.tags.pluck(:name).join(",")
      end

      def update
        @deck = current_user.decks.find(params[:id])
        tag_names = params[:deck][:name]
        if @deck.update(deck_params)
          if tag_names.present?
            tags = tag_names.split(",").map.uniq
            create_or_update_deck_tags(@deck, tags)
          end
          redirect_to deck_path(@deck), notice: t("decks.update.notice")
        else
          flash.now[:alert] = t("decks.update.alert")
          render :edit, status: :unprocessable_entity
        end
      end

    def create
        @deck = current_user.decks.build(deck_params)
        tag_names = params[:deck][:name]
        if @deck.save
          if tag_names.present?
            tags = tag_names.split(",").map.uniq
            create_or_update_deck_tags(@deck, tags)
          end
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

      def search_tag
        @tag = Tag.find_by(name: params[:name])
        @q = @tag.decks.ransack(params[:q])
        @decks = @q.result.order(created_at: :desc).page(params[:page])
        render :index
      end

    private

    def deck_params
        params.require(:deck).permit(:title, :description, :status, :deck_image, :deck_image_cache)
    end

    def create_or_update_deck_tags(deck, tag_list)
      if tag_list.blank?
        deck.tags = []
        return
      end

      deck.tags = []

      tag_list.each do |name|
        tag = Tag.find_or_create_by(name: name)
        deck.tags << tag unless deck.tags.include?(tag)
      end
    end
end

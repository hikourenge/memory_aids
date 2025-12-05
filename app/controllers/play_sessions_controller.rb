class PlaySessionsController < ApplicationController
    before_action :set_deck
    before_action :set_play_session, only: %i[show answer result]

    # POST /decks/:deck_id/play_sessions
    def create
        @play_session = @deck.play_sessions.new(play_session_params)

        @play_session.user = user_signed_in? ? current_user : nil
        @play_session.started_at = Time.current
        @play_session.correct_count = 0

        if @play_session.save
            redirect_to deck_play_session_path(@deck, @play_session)
        else
            @cards = @deck.cards.order(:position)
            flash.now[:alert] = "プレイを開始できませんでした。"
            render "decks/show", status: :unprocessable_entity
        end

    end

    # GET /decks/:deck_id/play_sessions/:id
    # 1問ずつ出題する画面
    def show
        answered_ids = @play_session.card_sessions.pluck(:card_id)
        @card = @deck.cards.order(:position).where.not(id: answered_ids).first

        if @card.nil?
        # 全問解き終わっていたら結果画面へ
        redirect_to result_deck_play_session_path(@deck, @play_session)
        end

        @hints = @card.hints.order(hint_position: :asc)
    end

    # PATCH /decks/:deck_id/play_sessions/:id/answer
    def answer
        @card = @deck.cards.find(params[:card_id])
        is_correct = ActiveModel::Type::Boolean.new.cast(params[:is_correct])

        CardSession.transaction do
        @play_session.card_sessions.create!(
            card: @card,
            is_correct: is_correct,
            duration_seconds: nil
        )

        # 毎回 correct_count を計算し直す
        correct = @play_session.card_sessions.where(is_correct: true).count
        @play_session.update!(correct_count: correct)

        # 全問終わったら終了処理
        if @play_session.card_sessions.count >= @deck.cards.count
            ended_at = Time.current
            @play_session.update!(
            ended_at: ended_at,
            total_time_seconds: (ended_at - @play_session.started_at).to_i
            )
            redirect_to result_deck_play_session_path(@deck, @play_session) and return
        end
        end

        redirect_to deck_play_session_path(@deck, @play_session)
    end

    # GET /decks/:deck_id/play_sessions/:id/result
    def result
      # @play_session の値からビューで表示
    end

    private

    def play_session_params
        params.require(:play_session).permit(:mode)
    end

    def set_deck
        @deck = Deck.find(params[:deck_id])
    end

    def set_play_session
        @play_session = PlaySession.find(params[:id])
    end

  #  def ensure_owner!
  #      redirect_to root_path, alert: "このプレイセッションにはアクセスできません" if @play_session.user != current_user
  #  end
end

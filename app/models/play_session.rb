class PlaySession < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :deck
    has_many :card_sessions, dependent: :destroy

    enum :mode, { practice: 0, exam: 1 }

    # 全カード数
    def total_questions
      deck.cards.count
    end

    # 正答数（正規化のため、カラムではなく関連から計算してもOK）
    def correct_questions
      card_sessions.where(is_correct: true).count
    end

    def accuracy
      return 0 if total_questions.zero?
      (correct_questions.to_f / total_questions * 100).round(1)
    end
end

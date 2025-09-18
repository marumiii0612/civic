class Association < ApplicationRecord
# 文字列 "1" ~ "19" / "1" ~ "3" の想定なら inclusion で厳密化
  Q1_SET = %w[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19].freeze
  Q2_SET = %w[1 2 3].freeze
  Q3_SET = %w[1 2 3].freeze
  Q4_SET = %w[1 2 3].freeze

  with_options presence: { message: 'を選択してください' } do
    validates :question1
    validates :question2
    validates :question3
    validates :question4
  end

  validates :question1, inclusion: { in: Q1_SET, message: 'の選択値が不正です' }
  validates :question2, inclusion: { in: Q2_SET, message: 'の選択値が不正です' }
  validates :question3, inclusion: { in: Q3_SET, message: 'の選択値が不正です' }
  validates :question4, inclusion: { in: Q4_SET, message: 'の選択値が不正です' }
end

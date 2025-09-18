class Tweet < ApplicationRecord
      # URLは任意、それ以外は必須
  with_options presence: true do
    validates :name
    validates :event
    validates :genre
    validates :datefrom
    validates :dateto
    validates :area
    validates :address
    validates :lat
    validates :lng
    validates :about
  end

  # 型のチェック（数値）
  validates :lat, numericality: true, allow_nil: false
  validates :lng, numericality: true, allow_nil: false

  # 終了が開始より後
  validate :date_order

  # eventurl は任意だが、入っていたら形式チェック（お好みで）
  validates :eventurl, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  private
  def date_order
    return if datefrom.blank? || dateto.blank?
    if dateto < datefrom
      errors.add(:dateto, "は開始時間以降を指定してください")
    end
  end
end

class StaticsController < ApplicationController
    # require 'csv'
    helper_method :safe_url, :url_host

def index
    @groups = Group.all.order(:number) # number順で表示（任意）
end

def search
  @groups = Group.all
  # 名前検索
  if params[:name].present?
    @groups = @groups.where("name LIKE ?", "%#{params[:name]}%")
  end
  # ジャンル検索
  if params[:genre].present?
    @groups = @groups.where("genre LIKE ?", "%#{params[:genre]}%")
  end
  # キャッチフレーズ検索
  if params[:keyword].present?
  kw = "%#{params[:keyword]}%"
  @groups = @groups.where(
    "catchphrase LIKE :kw OR purpose LIKE :kw OR about LIKE :kw",
    kw: kw
  )
end
  render :groupall
end

def groupall
    @groups = Group.all
end

def show
    @group = Group.find(params[:id])
end

def upload
    return unless request.post?  # POST時のみ取り込み

    # ①フォームからアップロード ②未選択なら db/csv/group.csv
    raw =
      if params[:file].present?
        params[:file].read
      else
        path = Rails.root.join('db', 'csv', 'group.csv')
        unless File.exist?(path)
          flash.now[:alert] = "CSVが見つかりません（db/csv/group.csv）。"
          return
        end
        File.binread(path)
      end

    # Excel想定: CP932→UTF-8変換＋BOM除去
    text = begin
      raw.dup.force_encoding('CP932').encode('UTF-8')
    rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
      raw.force_encoding('UTF-8')
    end
    text.sub!(/\A\xEF\xBB\xBF/, '')

    # 区切り自動推定（カンマ/タブ/セミコロン）
    head = text.lines.first.to_s
    col_sep =
      if head.count(';') > head.count(',') && head.count(';') > head.count("\t")
        ';'
      elsif head.count("\t") > head.count(',')
        "\t"
      else
        ','
      end

    rows = CSV.parse(text, headers: true, col_sep: col_sep)

    imported = 0
    skipped  = 0

    nullify = ->(h) { h.transform_values { |v|
      v.is_a?(String) ? (v.strip == "" ? nil : v.strip) : v
    }}

    ActiveRecord::Base.transaction do
      rows.each do |row|
        h = nullify.call(row.to_h)

        attrs = {
          number:        h['number'],
          name:          h['name'],
          catchphrase:   h['catchphrase'],
          purpose:       h['purpose'],
          about:         h['about'],
          phone:         h['phone'],
          mail:          h['mail'],
          g_area:        h['g_area'],
          g_address:     h['g_address'],
          genre:         h['genre'],
          establishment: h['establishment'],
          member:        h['member'],
          range:         h['range'],
          fee_year:      h['fee_year'],
          budget_2025:   h['budget_2025'],
          url:           h['url'],
        }.compact

        # 必須キー（例：number）。無ければ name 等に変更OK
        if attrs[:number].blank?
          skipped += 1
          next
        end

        rec = Group.find_or_initialize_by(number: attrs[:number])
        rec.assign_attributes(attrs.except(:number))
        rec.save!
        imported += 1
      end
    end

    flash.now[:notice] = "取り込み完了：imported=#{imported}, skipped=#{skipped}"
  rescue => e
    flash.now[:alert] = "取り込み失敗：#{e.class} #{e.message}"
  end

  def about
  end

  def civic
  end

  def safe_url(url)
    return "" if url.blank?
    url.to_s =~ /\Ahttps?:\/\//i ? url.to_s : "https://#{url}"
  end

  # 表示用にホストだけ取りたい時（任意）
  def url_host(url)
    require "uri"
    URI.parse(safe_url(url)).host rescue url
  end
end


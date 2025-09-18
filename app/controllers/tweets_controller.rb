class TweetsController < ApplicationController
    before_action :authenticate_user!, only: [:index, :new, :create, :edit, :destroy]

    def index
        @tweets = Tweet.all
    end

    def new
        @tweet = Tweet.new
    end

    def create
        tweet = Tweet.new(tweet_params)
        tweet.user_id = current_user.id
        if tweet.save
            redirect_to :action => "index"
        else
            redirect_to :action => "new"
        end
    end

    def eventall
        @tweets = Tweet.all
    end

    def show
        @tweet = Tweet.find(params[:id])
    end

    def search
        if params[:search] == nil
        @tweets= Tweet.all
      elsif params[:search] == ''
        @tweets= Tweet.all
      else
        #部分検索
        @tweets= Tweet.where("about LIKE :q OR name LIKE :q OR event LIKE :q",
    q: "%#{params[:search]}%")
      end
    end

    def area
        if params[:search] == nil
            @tweets= Tweet.all
        elsif params[:search] == ''
            @tweets= Tweet.all
        else
            @tweets = Tweet.where(area: params[:search])
        end
    end

    def genre
        if params[:search] == nil
            @tweets= Tweet.all
        elsif params[:search] == ''
            @tweets= Tweet.all
        else
            @tweets = Tweet.where(genre: params[:search])
        end
    end

    def month
        @month_param = params[:month]
    if @month_param.present?
        begin
            m = Date.strptime(@month_param, "%Y-%m")
        if Tweet.columns_hash["datefrom"].type.in?([:datetime, :timestamp])
            start_t = m.beginning_of_month.beginning_of_day
            end_t   = m.end_of_month.end_of_day
        else
            # date 型想定
            start_t = m.beginning_of_month
            end_t   = m.end_of_month
        end
        @tweets = Tweet.where("datefrom <= ? AND COALESCE(dateto, datefrom) >= ?", end_t, start_t)
        rescue ArgumentError
        flash.now[:alert] = "月の形式が不正です（YYYY-MM）"
        @tweets = Tweet.none
        end
    else
        @tweets = Tweet.all
    end
    end

    def name
        if params[:search] == nil
            @tweets= Tweet.all
        elsif params[:search] == ''
            @tweets= Tweet.all
        else
            @tweets= Tweet.where("name LIKE ? ",'%' + params[:search] + '%')
        end
    end

    def edit
        @tweet = Tweet.find(params[:id])
    end

    def update
    tweet = Tweet.find(params[:id])
    if tweet.update(tweet_params)
      redirect_to :action => "show", :id => tweet.id
    else
      redirect_to :action => "new"
    end
    end

    def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
    end

    private
    def tweet_params
        params.require(:tweet).permit(:name, :event, :genre, :datefrom, :dateto, :area, :address, :about, :eventurl, :lat, :lng)
    end
end

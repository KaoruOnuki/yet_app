class UsersController < ApplicationController
  before_action :redirect_if_not_logged_in, only: [:index, :create, :show, :edit, :update]
  before_action :redirect_if_wrong_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @followings = Relationship.where(follower_id: @user.id)
    @follows = Relationship.where(followed_id: @user.id)

    today = Date.today
    @number_of_words_today = Word.where(created_at: today.in_time_zone.all_day).where(user_id: @user.id).count
    @number_of_words_this_week = Word.where(created_at: today.in_time_zone.all_week).where(user_id: @user.id).count
    @number_of_words_this_month = Word.where(created_at: today.in_time_zone.all_month).where(user_id: @user.id).count

    if @user.target_of_the_day.present?
      if @user.target_of_the_day > @number_of_words_today
        @chart_data_of_the_day = [["今日登録した単語数：#{@number_of_words_today}単語", @number_of_words_today],
                                  ["今日の目標達成まで：#{@user.target_of_the_day - @number_of_words_today}単語", (@user.target_of_the_day - @number_of_words_today)]]
      else
        @chart_data_of_the_day = [["今日登録した単語数：#{@number_of_words_today}単語", @number_of_words_today], ["今日の目標単語数：#{@user.target_of_the_day}単語", 0]]
      end
    else
      @chart_data_of_the_day = [["今日登録した単語数：#{@number_of_words_today}単語", @number_of_words_today], ["ターゲットが設定されていません", 0]]
    end

    if @user.target_of_the_week.present?
      if @user.target_of_the_week > @number_of_words_this_week
        @chart_data_of_the_week = [["今週登録した単語数：#{@number_of_words_this_week}単語", @number_of_words_this_week],
                                   ["今週の目標達成まで：#{@user.target_of_the_week - @number_of_words_this_week}単語", (@user.target_of_the_week - @number_of_words_this_week)]]
      else
        @chart_data_of_the_week = [["今週登録した単語数：#{@number_of_words_this_week}単語", @number_of_words_this_week], ["今週の目標単語数：#{@user.target_of_the_week}単語", 0]]
      end
    else
      @chart_data_of_the_week = [["今週登録した単語数：#{@number_of_words_this_week}単語", @number_of_words_this_week], ["ターゲットが設定されていません", 0]]
    end

    if @user.target_of_the_month.present?
      if @user.target_of_the_month > @number_of_words_this_month
        @chart_data_of_the_month = [["今月登録した単語数：#{@number_of_words_this_month}単語", @number_of_words_this_month],
                                    ["今月の目標達成まで：#{@user.target_of_the_month - @number_of_words_this_month}単語", (@user.target_of_the_month - @number_of_words_this_month)]]
      else
        @chart_data_of_the_month = [["今月登録した単語数：#{@number_of_words_this_month}単語", @number_of_words_this_month], ["今月の目標単語数：#{@user.target_of_the_month}単語", 0]]
      end
    else
      @chart_data_of_the_month = [["今月登録した単語数：#{@number_of_words_this_month}単語", @number_of_words_this_month], ["ターゲットが設定されていません", 0]]
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_picture, :profile_picture_cache, :target_of_the_day, :target_of_the_week, :target_of_the_month)
  end
end

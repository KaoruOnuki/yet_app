class UsersController < ApplicationController
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
    number_of_words_today = Word.where(created_at: today.in_time_zone.all_day).where(user_id: @user.id).count
    number_of_words_this_week = Word.where(created_at: today.in_time_zone.all_week).where(user_id: @user.id).count
    number_of_words_this_month = Word.where(created_at: today.in_time_zone.all_month).where(user_id: @user.id).count

    a = @user.target_of_the_day - number_of_words_today
    b = @user.target_of_the_week - number_of_words_this_week
    c = @user.target_of_the_month - number_of_words_this_month

    @chart_data_of_the_day = [["今日登録した単語数\n#{number_of_words_today}単語", number_of_words_today],
                              ["ターゲット達成まで\n#{a}単語", a ]]

    @chart_data_of_the_week = [["今週登録した単語数\n#{number_of_words_this_week}単語", number_of_words_this_week],
                               ["ターゲット達成まで\n#{b}単語", b ]]

    @chart_data_of_the_month = [["今月登録した単語数\n#{number_of_words_this_month}単語", number_of_words_this_month],
                                ["ターゲット達成まで\n#{c}単語", c ]]
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

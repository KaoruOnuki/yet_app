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

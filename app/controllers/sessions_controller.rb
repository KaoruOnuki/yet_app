class SessionsController < ApplicationController
  def new
    render layout: "second_layout"
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome to YET"
      redirect_to user_path(user.id)
    else
      flash[:danger] = "ログインできません"
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "ログアウトしました"
    redirect_to new_session_path
  end
end

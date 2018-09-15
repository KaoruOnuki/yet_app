module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def set_user
    @user = current_user
  end

  def redirect_if_not_logged_in
    redirect_to new_session_path if !logged_in?
  end

  def redirect_if_wrong_user
    @user = User.find(params[:id])
    redirect_to new_session_path if @user != current_user
  end
end

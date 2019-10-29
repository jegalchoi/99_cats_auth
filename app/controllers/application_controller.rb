class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?
  helper_method :owner?

  private

  def require_no_user!
    redirect_to cats_url if current_user
  end

  def logged_in?
    !!current_user
  end

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def require_user!
    redirect_to new_session_url if current_user.nil?
  end

  def owner?
    redirect_to cat_url unless current_user.cats.find_by(id: params[:id])
  end
end

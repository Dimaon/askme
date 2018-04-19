class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Для доступа во всех views
  helper_method :current_user

  private

  def auth_after_user_create

  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    redirect_to root_path, alert: 'Доступ запрещен!'
  end
end

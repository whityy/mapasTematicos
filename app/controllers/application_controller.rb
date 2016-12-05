class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.


  protected
  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password) }
  	devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :username, :email, :password, :current_password) }
  end

  def after_sign_in_path_for(resource)
  	maps_path
  end
end

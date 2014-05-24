class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :my_terms

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def my_terms
    @user = current_user
    (@user.name == 'admin') ? Term.all : @user.terms
  end

end

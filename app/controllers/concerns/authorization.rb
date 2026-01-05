# app/controllers/concerns/authorization.rb
module Authorization
  extend ActiveSupport::Concern
  
  included do
    helper_method :current_user_admin?
  end
  
  private
    def require_admin
      unless Current.user&.admin?
        redirect_to root_path, alert: "You must be an admin to access this page."
      end
    end
    
    def current_user_admin?
      Current.user&.admin?
    end
end

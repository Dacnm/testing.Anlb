module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.not_validates_password = true
    user.update_attributes! remember_token: User.encrypt(remember_token)
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    current_user.not_validates_password = true
    current_user.update_attributes! remember_token:
                                  User.encrypt(User.new_remember_token)
    cookies.delete(:remember_token)
    self.current_user = nil
  end

end

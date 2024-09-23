class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "Email with password reset instructions sent."
      redirect_to root_url
    else
      flash.now[:alert] = "Email address not found"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      log_in @user
      flash[:notice] = "Password has been changed"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email].downcase)
  end

  def valid_user
    unless @user && !@user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url, alert: "Invalid password reset link"
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:alert] = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

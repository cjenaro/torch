class UsersController < ApplicationController
  before_action :set_user, only: [ :update, :destroy ]
  before_action :require_login, only: [ :update, :destroy ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:notice] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_update_params)
      redirect_to current_user
    else
      Rails.logger.debug @user.errors
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO
  end

  def show
    @user = User.find(params[:id])
    @workspaces = @user.workspaces
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :avatar_attachment)
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end

  def set_user
    @user = current_user
  end
end

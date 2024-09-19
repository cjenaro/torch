class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      log_in user
      flash[:notice] = "Logged in successfully."
      redirect_to user
    else
      flash.now[:alert] = "Invalid credentials"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = "Logged out successfully"
    redirect_to root_url
  end
end

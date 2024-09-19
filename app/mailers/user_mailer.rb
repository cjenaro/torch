class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    @activation_url = edit_account_activation_url(@user.activation_token, email: @user.email)
    mail to: @user.email, subject: "Activate your Torch account"
  end
end

module ApplicationHelper
  def gravatar
    hash = Digest::SHA256.hexdigest(current_user.email.downcase)
    
    default = current_user.avatar
    size = 40

    params = URI.encode_www_form('d' => default, 's' => size)
    "https://www.gravatar.com/avatar/#{hash}?#{params}"
  end
end

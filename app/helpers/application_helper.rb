module ApplicationHelper
  def gravatar
    if current_user.avatar_attachment
      return url_for(current_user.avatar_attachment)
    end

    hash = Digest::SHA256.hexdigest(current_user.email.downcase)

    default = "https://fav.farm/🔥"
    size = 200

    params = URI.encode_www_form("d" => default, "s" => size)
    "https://www.gravatar.com/avatar/#{hash}?#{params}"
  end
end

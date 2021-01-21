module FriendshipsHelper
  def check_status(user)
    if !current_user.pending_friends.include?(user) && !user.pending_friends.include?(current_user)
      false
    elsif current_user.pending_friends.include?(user) || user.pending_friends.include?(current_user)
      true
    end
  end

  def add_friend(user)
    if !current_user.friend?(user) &&
       user != current_user && check_status(user) == false &&
       !user.friends.include?(current_user)
      true
    else
      false
    end
  end

  def cancel_friend?(user)
    (unless check_status(user) == true &&
     user != current_user &&
     current_user.friendships.find_by(friend_id: user.id)
       return; end)
    check_status(user) == true && user != current_user && user1 = current_user.friendships.find_by(friend_id: user.id)
    form_for(user1,
             html: { method: :delete }) do |f|
      f.submit 'cancel', class: 'btn'
    end
  end

  def accept_or_decline(user, requester, accepter)
    return unless current_user.friend_requests.include?(user)

    return unless current_user.friend_requests.include?(user) &&
                  user != current_user &&
                  !current_user.friends.include?(user) && check_status(user) == true &&
                  !user.friends.include?(current_user) && (requester == accepter)

    concat button_to 'Accept Friend Request', friendship_path(id: requester), class: 'Accept', method: :put
    button_to 'Decline Friend Request', friendship_path(id: accepter), class: 'cancel', method: :delete
  end

  def number_of_request(user)
    return unless !current_user.friend_requests.blank? && current_user == user

    content_tag(:div, "you have #{current_user.friend_requests.count} request pending", class: '')
  end

  def mutual_friends?(user)
    return unless current_user.friend?(user)

    mutual_friends = current_user.friends.where(users: { id: user.friends.pluck(:id) })
    content_tag(:div, "you have #{mutual_friends.count} mutual friends", class: '')
  end
end


class FriendshipsController < ApplicationController
  def index
    @my_friends = current_user.friends
  end

  def create
    @friendship = current_user.friendships.build(params_friendship)
    if @friendship.save
      flash[:notice] = 'Friendship was saved correctly.'
      redirect_to users_path
    else
      render :create
    end
  end

  def update
    friend = User.find(params[:id])
    friendship = friend.friendships.find_by(friend_id: current_user.id)
    if current_user.friend_requests.include?(friend)
      friendship.confirm_friend
      flash[:notice] = "You are now friends.#{friend.name}"
      redirect_to users_path
    end
  end

  def destroy
    if Friendship.exists?(params[:id])
     @friendship=Friendship.find(params[:id])
      @friendship.destroy
    else
      @friendship = Friendship.where(friend_id: [current_user, params[:id]], user_id: [current_user, params[:id]]).first
      @friendship.destroy
    end

    redirect_to users_path
  end

  private

  def params_friendship
    params.require(:friendship).permit(:friend_id, :user_id)
  end
end


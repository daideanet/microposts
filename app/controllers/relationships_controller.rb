class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
    relationship  = Relationship.find_by(id: params[:id], follower_id: current_user.id)
    relationship.destroy if relationship.present?
    # @user = current_user.following_relationships.find(params[:id]).followed
    # current_user.unfollow(@user)
  end
end
class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:like_micropost_id])
    current_user.like(@micropost)
    # redirect_to :back
  end

  def destroy
    @micropost = current_user.likes.find(params[:id]).micropost
    current_user.unlike(@micropost)
    # redirect_to :back
  end
  
end

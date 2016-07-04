class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :area, presence: true, length: { maximum: 50 }, on: :update
  validates :profile, presence: true, length: { maximum: 150 }, on: :update
  has_secure_password
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
  has_many :likes, dependent: :destroy

  has_many :like_microposts, through: :likes, source: :micropost
 
    # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  def feed_items
    Micropost.where(user_id: self.following_user_ids + [self.id])
  end
  
  # 他のユーザーの投稿をお気に入りする
  def like(other_micropost)
    likes.find_or_create_by(micropost_id: other_micropost.id)
  end
  
  # 他のユーザーの投稿をお気に入りを解除する
def unlike(micropost)
  like =  likes.find_by(micropost_id: micropost.id)
  like.destroy if like
end

  # あるユーザーの投稿をお気に入りしているかどうか？
  def like?(micropost)
    like_microposts.include?(micropost)
  end
end

# ・likesの場合は、複合インディックスはいらないのか？ 
# ・following_relationshipsにあたる、user_like　のモデルはいらない？ 
# ・ def destroy 
# 　　　@user = current_user.following_relationships.find(params[:id]).followed
# 　　　current_user.unfollow(@user)
# 　end 
# 　この.followedの意味は？
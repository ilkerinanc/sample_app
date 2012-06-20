class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  default_scope order: 'microposts.created_at DESC'

  scope :from_users_followed_by, lambda { |user|
      followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
      where("(
        (
          microposts.user_id IN (#{followed_user_ids})
        ) AND (
          (
            microposts.in_reply_to IS NOT NULL AND (microposts.in_reply_to IN (#{followed_user_ids}) OR microposts.in_reply_to = :user_id)
          ) OR (
            microposts.in_reply_to IS NULL
          )
        )
      ) OR (
        microposts.user_id = :user_id
      )", user_id: user.id)
  }
end
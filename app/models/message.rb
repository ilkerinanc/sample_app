class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id
  
  belongs_to :user

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true, length: {maximum: 160}
  default_scope order: 'messages.created_at ASC'
  
  scope :sent_to, lambda { |user|
  	where("receiver_id = :user_id", user_id: user.id)
  }

  scope :sent_by, lambda { |user|
  	where("sender_id = :user_id", user_id: user.id)
  }
end
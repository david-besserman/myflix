class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false
  has_many :queue_items, -> {order("position")}
  has_many :reviews, -> {order("created_at DESC")}
  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  # should return all the relationships where the user is the follower

  before_create :generate_token

  def new_queue_item_position
    queue_items.count + 1
  end
  
  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def owner?(queue_item)
    queue_items.include?(queue_item)
  end

  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: (index + 1))
    end
  end

  def can_follow?(leader)
    !(already_follows?(leader)) || is?(leader)
  end

  def already_follows?(another_user)
    !!Relationship.find_by(leader: another_user, follower: self)
  end

  def is?(user)
    self == user
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

end

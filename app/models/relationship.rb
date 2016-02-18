class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :leader, class_name: 'User'
  validates_presence_of :follower
  validates_presence_of :leader
  validate :follower_different_from_leader

  private

  def follower_different_from_leader
    if follower == leader
      errors.add(:follower, "You can't follow yourself")
    end
  end
end

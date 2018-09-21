class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  before_save { email.downcase! }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_many :words, dependent: :destroy

  mount_uploader :profile_picture, ProfilepictureUploader

  has_many :contacts, dependent: :destroy

  has_many :active_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :passive_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validate :day_target_cannot_be_bigger_than_week_target
  validate :week_target_cannot_be_bigger_than_month_target

  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def day_target_cannot_be_bigger_than_week_target
    if self.target_of_the_day.present? && self.target_of_the_week.present?
      errors.add(:target_of_the_day, "は1週間/1ヶ月の目標単語数を上回りません") unless self.target_of_the_day < self.target_of_the_week
    end
  end

  def week_target_cannot_be_bigger_than_month_target
    if self.target_of_the_week.present? && self.target_of_the_month.present?
      errors.add(:target_of_the_week, "は1ヶ月の目標単語数を上回りません") unless self.target_of_the_week < self.target_of_the_month
    end
  end
end

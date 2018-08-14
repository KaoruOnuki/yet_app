class User < ApplicationRecord
  before_save { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end

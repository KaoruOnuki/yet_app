class Word < ApplicationRecord
  before_save { term.downcase! }
  validates :term, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :memo, presence: true, length: { maximum: 300 }
  belongs_to :user
end

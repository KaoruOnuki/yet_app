class Word < ApplicationRecord
  validates :term, presence: true, length: { maximum: 50 }
  validates :memo, presence: true, length: { maximum: 300 }
  belongs_to :user
end

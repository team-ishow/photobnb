class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  
  #必須項目
  validates :photo_type, presence: true
  validates :camera_type, presence: true
  validates :photo_time, presence: true
  validates :finish_time, presence: true
  
end

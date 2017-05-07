class Image < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :feed_backs, class_name: FeedBack.name, foreign_key: :image_id,
    dependent: :destroy

  validates :user, presence: true
  validates :category, presence: true

  mount_uploader :image, ImageUploader

  scope :popular_images, -> {order like_number: :desc, id: :desc}

  def main_comments
    comments.where(parent_id: nil).order id: :desc
  end

  def likes
    feed_backs.like
  end
end

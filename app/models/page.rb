class Page < ApplicationRecord
  belongs_to :parent, class_name: "Page", optional: true
  belongs_to :workspace
  belongs_to :creator, class_name: "User", polymorphic: true

  has_many :children, class_name: "Page", foreign_key: "parent_id", dependent: :destroy

  has_many :blocks, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }

  attribute :is_template, :boolean, default: false
end

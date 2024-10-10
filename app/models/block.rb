class Block < ApplicationRecord
  BLOCK_TYPES = [ "text", "heading_1", "heading_2", "heading_3", "bulleted_list", "numbered_list", "to_do", "quote", "code", "image", "database" ]

  belongs_to :page
  has_many :children, class_name: "Block", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Block", optional: true
  acts_as_list scope: :page

  has_many :database_entries, foreign_key: "block_id", dependent: :destroy

  has_one_attached :attachment
  has_rich_text :content

  validates :block_type, inclusion: { in: BLOCK_TYPES }
  validates :content, presence: true, if: :content_required?

  default_scope { order(position: :asc) }

  private
  def content_required?
    %w[list checklist code quote].include?(block_type)
  end
end

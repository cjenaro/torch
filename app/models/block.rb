class Block < ApplicationRecord
  belongs_to :page
  acts_as_list scope: :page

  has_many :database_entries, foreign_key: 'block_id', dependent: :destroy

  has_one_attached :attachment
  has_rich_text :content

  validates :block_type, presence: true
  validates :content, presence: true, if: :content_required?

  default_scope { order(position: :asc) }

  private
  def content_required?
    %w[text heading list checklist code quote].include?(block_type)
  end
end

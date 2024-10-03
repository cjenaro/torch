class DatabaseEntry < ApplicationRecord
  belongs_to :block

  validates :properties, presence: true

  validate :properties_match_schema

  private

  def properties_match_schema
    schema = block.data['schema'] || []
    schema.each do |field|
      field_name = field['name']
      if field['required'] && properties[field_name].blank?
        errors.add(:properties, "#{field_name} is required")
      end
    end
  end
end

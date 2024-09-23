class Workspace < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :pages, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :name, presence: true
end

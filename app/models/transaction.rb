class Transaction < ActiveRecord::Base
  validates :name, presence: true
  has_one :bank_guarantee
end

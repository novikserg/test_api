class Transaction < ActiveRecord::Base
  validates :name, presence: true
  has_one :bank_guarantee
  
  def deactivate!
    self.active = false
    save
    bank_guarantee.try(:deactivate!)
  end
end

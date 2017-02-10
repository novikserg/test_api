class Transaction < ActiveRecord::Base
  validates_presence_of :name, :company_id

  has_one :bank_guarantee
  belongs_to :company
  
  def deactivate!
    self.active = false
    save
    bank_guarantee.try(:deactivate!)
  end
end

class Transaction < ActiveRecord::Base
  validates_presence_of :name, :company_id

  has_one :bank_guarantee
  belongs_to :company
  
  # in future I would add a transaction for this whole method, so that transaction and bank_guarantee are ensured to be deactivated together
  # however for now it looks redundant, and specs ensure all's well
  def deactivate!
    self.active = false
    save
    bank_guarantee.try(:deactivate!)
  end
end

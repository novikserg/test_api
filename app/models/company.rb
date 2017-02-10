class Company < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :confirmable
  
  has_many :transactions
  has_many :bank_guarantees
end

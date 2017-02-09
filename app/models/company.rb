class Company < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :confirmable
end

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include StandardApiErrors
  protect_from_forgery with: :null_session
end

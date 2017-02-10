class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ApiErrors
  protect_from_forgery with: :null_session
end

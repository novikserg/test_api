module ControllersHelper
  def token_sign_in(company)
    auth_headers = company.create_new_auth_token
    request.headers.merge!(auth_headers)
  end
end

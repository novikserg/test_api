module RequestsHelper
  def authorized_get(company, path, params = {})
    auth_headers = company.create_new_auth_token
    headers = { "ACCEPT" => "application/json" }.merge(auth_headers)
    get(path, params, headers)
  end

  def authorized_post(company, path, params = {})
    auth_headers = company.create_new_auth_token
    headers = { "ACCEPT" => "application/json" }.merge(auth_headers)
    post(path, params, headers)
  end
  
  def authorized_put(company, path, params = {})
    auth_headers = company.create_new_auth_token
    headers = { "ACCEPT" => "application/json" }.merge(auth_headers)
    put(path, params, headers)
  end
  
  def authorized_delete(company, path)
    auth_headers = company.create_new_auth_token
    headers = { "ACCEPT" => "application/json" }.merge(auth_headers)
    delete(path, headers)
  end
end

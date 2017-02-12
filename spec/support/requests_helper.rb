module RequestsHelper
  def authorized_get(*args)
    request(:get, *args)
  end

  def authorized_post(*args)
    request(:post, *args)
  end
  
  def authorized_put(*args)
    request(:put, *args)
  end
  
  def authorized_delete(*args)
    request(:delete, *args)
  end
  
  private
  
  def request(http_method, company, path, params = {})
    auth_headers = company.create_new_auth_token
    headers = { "ACCEPT" => "application/json" }.merge(auth_headers)
    send(http_method, path, params: params, headers: headers)
  end
end

module AuthenticationHelper
  def sign_in(user)
    if defined?(controller)
      allow(controller).to receive(:current_user).and_return(user)
      # For request specs
      auth_token = user.generate_auth_token
      request.headers['Authorization'] = "Bearer #{auth_token}"
    elsif defined?(page) && defined?(Capybara)
      page.driver.browser.add_headers('Authorization' => "Bearer #{user.generate_auth_token}")
    end
  end
end

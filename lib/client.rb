class Client
  include HTTParty

  attr_reader :config, :auth, :payload, :customer_url

  def initialize(configuration, payload)
    @config = configuration
    @auth = {
      username: configuration['desk_username'],
      password: configuration['desk_password']
    }
    @payload = payload
  end

  def import
    @customer_url = get_or_create_customer
    create_case
  end

  def create_case
    options = {
      headers: { 'Content-Type' => 'application/json' },
      body: case_params.to_json,
      basic_auth: auth
    }
    response = self.class.post("#{config['desk_url']}/api/v2/cases", options)
    if validate_response(response)
      response
    end
  end

  def get_customer
    options = {
      basic_auth: auth,
      body: { email: config['desk_customer_email'] }.to_json
    }
    response = self.class.get("#{config['desk_url']}/api/v2/customers/search", options)
    if validate_response(response)
      begin
        response["_embedded"]["entries"].first["_links"]["self"]["href"]
      rescue Exception => e
        :customer_not_found
      end
    end
  end

  def create_customer
    options = {
      basic_auth: auth,
      body: {
        first_name: "Spree Commerce",
        last_name: "Hub",
        emails: [
          {
            type: "work",
            value: config['desk_customer_email']
          }
        ]
      }.to_json
    }
    response = self.class.post("#{config['desk_url']}/api/v2/customers", options)
    if validate_response(response)
      response["_links"]["self"]["href"]
    end
  end

  private

  def validate_response(response)
    if response['message'].present?
      raise ApiError, response['message']
    else
      true
    end
  end

  def case_params
    {
      type: 'email',
      subject: payload['subject'],
      message: message_params,
      status: 'new',
      '_links' => {
        customer: {
          href: "#{customer_url}",
          class: 'customer'
        }
      }
    }
  end

  def message_params
    {
      direction: 'in',
      to: config['desk_to_email'],
      from: "#{config['desk_requester_name']} (#{config['desk_requester_email']})",
      subject: payload['subject'],
      body: payload['description'],
      status: "received"
    }
  end

  def get_or_create_customer
    customer = get_customer
    customer == :customer_not_found ? create_customer : customer
  end
end

class ApiError < StandardError; end

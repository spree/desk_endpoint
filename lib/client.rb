class Client
  include HTTParty

  attr_reader :config, :auth, :message, :payload, :customer_url

  def initialize(configuration, message, payload)
    @config = configuration
    @auth = { username: configuration['desk.username'], password: configuration['desk.password'] }
    @message = message
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
    response = self.class.post("#{config['desk.url']}/api/v2/cases", options)
    if validate_response(response)
      response
    end
  end

  def get_customer
    options = {
      basic_auth: auth,
      body: { email: config['desk.customer_email'] }.to_json
    }
    response = self.class.get("#{config['desk.url']}/api/v2/customers/search", options)
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
            value: config['desk.customer_email']
          }
        ]
      }.to_json
    }
    response = self.class.post("#{config['desk.url']}/api/v2/customers", options)
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
      to: config['desk.to_email'],
      from: "#{config['desk.requester_name']} (#{config['desk.requester_email']})",
      subject: payload['subject'],
      body: payload['description']
    }
  end

  def get_or_create_customer
    customer = get_customer
    customer == :customer_not_found ? create_customer : customer
  end
end

class ApiError < StandardError; end

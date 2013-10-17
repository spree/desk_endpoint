class Client
  include HTTParty

  attr_reader :config, :auth, :message, :payload

  def initialize(configuration, message, payload)
    @config = configuration
    @auth = { username: configuration['desk.username'], password: configuration['desk.password'] }
    @message = message
    @payload = payload
  end

  def import
    options = {
      headers: { 'Content-Type' => 'application/json' },
      body: case_params.to_json,
      basic_auth: auth
    }
    self.class.post("#{config['desk.url']}/cases", options)
  end

  def case_params
    {
      type: 'email',
      subject: payload['subject'],
      message: message_params,
      '_links' => {
        customer: {
          href: '/api/v2/customers/124271370',
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
end

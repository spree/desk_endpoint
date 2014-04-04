require "sinatra"
require "endpoint_base"

require_relative './lib/client'

class DeskEndpoint < EndpointBase::Sinatra::Base
  post '/create_ticket' do
    begin
      client = Client.new(@config, @payload)
      new_case = client.import

      result 200, "New Desk case '#{new_case['subject']}' created, priority: #{new_case['priority']}."
    rescue Exception => e
      result 500, e.message
    end
  end
end

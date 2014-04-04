require "sinatra"
require "endpoint_base"

require_relative './lib/client'

class DeskEndpoint < EndpointBase::Sinatra::Base
  post '/import' do
    begin
      client = Client.new(@config, @payload)
      new_case = client.import

      code = 200

      result = {
        "notifications" => [{
          "level" => "info",
          "subject" => "Case created",
          "description" => "New Desk case '#{new_case['subject']}' created, priority: #{new_case['priority']}."
          }]
      }
    rescue Exception => e
      code = 500
      result = { "error" => e.message, "trace" => e.backtrace.inspect }
    end
    result code, result
  end
end

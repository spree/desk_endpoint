require 'endpoint_base'

Dir['./lib/*.rb'].each { |f| require f }

class DeskEndpoint < EndpointBase
  helpers Sinatra::JSON

  post '/import' do
    begin
      client = Client.new(@config)
      import = Import.new(client.fetch, @message[:message], @message[:payload], @config)
      ticket = import.ticket
      code = 200
      # result = { "message_id" => @message[:message_id], "notifications" => [ { "level" => "info",
      #   "subject" => "Help ticket created", "description" => "New Zendesk ticket number #{ticket.id} created, priority: #{ticket.priority}." } ] }
    rescue Exception => e
      code = 500
      result = { "error" => e.message, "trace" => e.backtrace.inspect }
    end
    process_result code, result
  end
end

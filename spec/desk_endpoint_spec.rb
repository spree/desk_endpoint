require 'spec_helper'

describe DeskEndpoint do
  def app
    described_class
  end

  let(:error_notification_payload) do
    { "ticket" => { "subject" => "Invalid China Order", "description" => "This order is shipping to China but was invalidly sent to PCH" } }
  end

  let(:warning_notification_payload) do
    { "ticket" => { "subject" => "Item out of stock", "description" => "This products requested in this order are not in stock." } }
  end

  let(:info_notification_payload) do
    { "ticket" => { "subject" => "Order Received", "description" => "You have received an order." } }
  end

  params = {
      'desk_username' => 'hub@spreecommerce.com',
      'desk_password' => 'foobar',
      'desk_url' => 'https://spreecommerce.desk.com',
      'desk_requester_name' => 'Spree Integrator',
      'desk_requester_email' => 'support@spreecommerce.com',
      'desk_to_email' => 'user@spreecommerce.com'
  }

  it "should respond to POST error notification import" do
    error_notification_payload['parameters'] = params

    VCR.use_cassette('error_notification_import') do
      post '/create_ticket', error_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /New Desk case/
    end
  end

  it "should respond to POST warning notification import" do
    warning_notification_payload['parameters'] = params

    VCR.use_cassette('warning_notification_import') do
      post '/create_ticket', warning_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /New Desk case/
    end
  end
end

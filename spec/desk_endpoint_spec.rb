require 'spec_helper'

describe DeskEndpoint do
  def app
    described_class
  end

  let(:error_notification_payload) do
    { "subject" => "Invalid China Order", "description" => "This order is shipping to China but was invalidly sent to PCH" }
  end

  let(:warning_notification_payload) do
    { "subject" => "Item out of stock", "description" => "This products requested in this order are not in stock." }
  end

  let(:info_notification_payload) do
    { "subject" => "Order Received", "description" => "You have received an order." }
  end

  params = {
      'desk_username' => 'user@spreecommerce.com',
      'desk_password' => 'foobar',
      'desk_url' => 'https://spreecommerce.desk.com',
      'desk_requester_name' => 'Spree Integrator',
      'desk_requester_email' => 'support@spreecommerce.com',
      'desk_to_email' => 'user@spreecommerce.com'
  }

  it "should respond to POST error notification import" do
    error_notification_payload['parameters'] = params

    VCR.use_cassette('error_notification_import') do
      post '/import', error_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /Case created/
    end
  end

  it "should respond to POST warning notification import" do
    warning_notification_payload['parameters'] = params

    VCR.use_cassette('warning_notification_import') do
      post '/import', warning_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /Case created/
    end
  end
end

require 'spec_helper'

describe DeskEndpoint do
  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
  end

  def app
    described_class
  end

  let(:error_notification_payload) { { "message" => "notification:error", "message_id" => "518726r84910515003", "payload" => { "subject" => "Invalid China Order", "description" => "This order is shipping to China but was invalidly sent to PCH" } } }
  let(:warning_notification_payload) { { "message" => "notification:warn", "message_id" => "518726r84910515004", "payload" => { "subject" => "Item out of stock", "description" => "This products requested in this order are not in stock." } } }
  let(:info_notification_payload) { { "message" => "notification:info", "message_id" => "518726r84910515005", "payload" => { "subject" => "Order Received", "description" => "You have received an order." } } }

  params = [
      { 'name' => 'desk.username', 'value' => 'user@spreecommerce.com' },
      { 'name' => 'desk.password', 'value' => 'foobar' },
      { 'name' => 'desk.url', 'value' => 'https://spreecommerce.desk.com/api/v2' },
      { 'name' => 'desk.requester_name', 'value' => 'Spree Integrator' },
      { 'name' => 'desk.requester_email', 'value' => 'support@spreecommerce.com' },
      { 'name' => 'desk.to_email', 'value' => 'user@spreecommerce.com' } ]

  it "should respond to POST error notification import" do
    error_notification_payload['payload']['parameters'] = params

    VCR.use_cassette('error_notification_import') do
      post '/import', error_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /Case created/
    end
  end

  it "should respond to POST warning notification import" do
    warning_notification_payload['payload']['parameters'] = params

    VCR.use_cassette('warning_notification_import') do
      post '/import', warning_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /Case created/
    end
  end

  it "should respond to POST info notification import" do
    info_notification_payload['payload']['parameters'] = params

    VCR.use_cassette('info_notification_import') do
      post '/import', info_notification_payload.to_json, auth
      last_response.status.should == 200
      last_response.body.should match /Case created/
    end
  end
end

require 'spec_helper'

describe Client do
  let(:configuration) do
    {
      'desk.username' => 'user@spreecommerce.com',
      'desk.password' => 'foobar',
      'desk.url' => 'https://spreecommerce.desk.com',
      'desk.requester_name' => 'Spree Commerce Hub',
      'desk.requester_email' => 'support@spreecommerce.com',
      'desk.to_email' => 'user@spreecommerce.com'
    }
  end
  let(:message) { { "message" => "notification:error", "message_id" => "518726r84910515003", "payload" => { "subject" => "Invalid China Order", "description" => "This order is shipping to China but was invalidly sent to PCH" } } }

  subject do
    Client.new(configuration, message[:message], message[:payload])
  end

  describe "#import" do
    it "creates a new case" do
      subject.should_receive(:get_or_create_customer).and_return("/api/v2/customers/124271370")
      subject.should_receive(:case_params).and_return({})
      Client.should_receive(:post).and_return('')

      subject.import
    end

    it "creates a new customer when one doesn't exist for hub@spreecommerce.com" do

    end

    it "users the existing customer when one exists for hub@spreecommerce.com" do

    end
  end
end

require 'spec_helper'

describe Client do
  let(:configuration) do
    {
      'desk_username' => 'hub@spreecommerce.com',
      'desk_password' => 'foobar',
      'desk_url' => 'https://spreecommerce.desk.com',
      'desk_requester_name' => 'Spree Commerce Hub',
      'desk_requester_email' => 'support@spreecommerce.com',
      'desk_to_email' => 'user@spreecommerce.com'
    }
  end
  let(:message) do
    { "subject" => "Invalid China Order", "description" => "This order is shipping to China but was invalidly sent to PCH" }
  end

  subject do
    Client.new(configuration, message)
  end

  describe "#get_customer" do
    it "returns the customer url if they exist" do
      configuration['desk_customer_email'] = 'hub@spreecommerce.com'
      VCR.use_cassette('get_customer_exists') do
        response = subject.get_customer
        response.should =~ /api\/v2\/customers/
      end
    end

    it "returns :customer_not_found if they don't exist" do
      configuration['desk_customer_email'] = 'hub992@spreecommerce.com'
      VCR.use_cassette('get_customer_nonexistant') do
        response = subject.get_customer
        response.should == :customer_not_found
      end
    end

    it "raises an error for an invalid response" do
      configuration['desk_password'] = 'invalid_pass'
      VCR.use_cassette('get_customer_error') do
        lambda { subject.get_customer }.should raise_error(ApiError, 'Invalid Credentials')
      end
    end
  end

  describe "#create_customer" do
    it "returns the newly created customer's url" do
      configuration['desk_customer_email'] = 'hub901@spreecommerce.com'
      VCR.use_cassette('create_customer') do
        response = subject.create_customer
        response.should =~ /api\/v2\/customers/
      end
    end

    it "raises an error for an invalid response" do
      configuration['desk_password'] = 'invalid_pass'
      VCR.use_cassette('create_customer_error') do
        lambda { subject.create_customer }.should raise_error(ApiError, 'Invalid Credentials')
      end
    end
  end

  describe "#create_case" do
    it "creates a new case" do
      subject.should_receive(:customer_url).and_return('/api/v2/customers/199586920')
      configuration['desk_customer_email'] = 'hub@spreecommerce.com'

      VCR.use_cassette('create_case') do
        response = subject.create_case
        response['subject'].should == 'Invalid China Order'
        response['created_at'].should be_present
      end
    end

    it "raises an error for an invalid response" do
      configuration['desk_password'] = 'invalid_pass'
      VCR.use_cassette('create_case_error') do
        lambda { subject.create_case }.should raise_error(ApiError, 'Invalid Credentials')
      end
    end
  end
end

require "spec_helper"

describe HookMailer do
  describe "#create_receipt" do
    before(:each) do
      @payload = "payload_text"
      @email = HookMailer.hook_email(:payload => @payload, :attachments => [{:name => "en.yml", :data => "123"}, {:name => "de.yml", :data => "456"}])
    end

    it "should put payload into body" do
      @email.should have_body_text(@payload)
    end

    it "should has attachments" do
      @email.attachments.count.should == 2

      @email.attachments[0].filename.should == "de.yml"
      @email.attachments[1].filename.should == "en.yml"
    end
  end
end

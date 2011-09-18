require 'spec_helper'

describe Github do
  describe "#fetch_raw_data" do
    it "should generate correct url" do
      Github.should_receive(:get).with("https://raw.github.com/matz/rails/master/config/application.rb")
      Github.fetch_raw_data(:user => "matz", :repo => "rails", :branch => "master", :path => "config/application.rb")
    end
  end
end

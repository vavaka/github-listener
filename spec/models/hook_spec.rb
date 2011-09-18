require 'spec_helper'

describe Hook do
  before(:each) do
    @payload = fixture("hook.json")
    @hook = Hook.new(@payload)
  end

  describe "#affected_files" do
    it "should return all modified but not removed files" do
      expected_array = [
        "README",
        "config/application.rb",
        "config/locales/de.yml",
        "config/locales/us.yml"
      ]

      @hook.affected_files.should =~ expected_array
    end
  end

  describe "#affected_i18n_files" do
    it "should return all affected i18n files" do
      expected_array = [
        "config/locales/de.yml",
        "config/locales/us.yml"
      ]

      @hook.affected_i18n_files.should =~ expected_array
    end
  end

  describe "#handle" do
    it "should download affected i18n files from github, save them to tmp directory and email them" do
      @hook.should_receive(:affected_i18n_files).and_return(["config/locales/en.yml", "config/locales/de.yml"])

      Github.should_receive(:fetch_raw_data).with({:user=>"vavaka", :repo=>"github-hooks-test", :branch=>"master", :path=>"config/locales/en.yml"}).and_return("123")
      @hook.should_receive(:save_to_tmp).with("config/locales/en.yml", "123")

      Github.should_receive(:fetch_raw_data).with({:user=>"vavaka", :repo=>"github-hooks-test", :branch=>"master", :path=>"config/locales/de.yml"}).and_return("456")
      @hook.should_receive(:save_to_tmp).with("config/locales/de.yml", "456")

      message = mock()
      message.should_receive(:deliver).once

      HookMailer.should_receive(:mail).with({:payload => @payload, :attachments => [{:name => "en.yml", :data => "123"}, {:name => "de.yml", :data => "456"}]}).and_return(message)
      @hook.handle
    end
  end
end

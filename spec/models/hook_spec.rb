require 'spec_helper'

describe Hook do
  describe "#affected_files" do
    it "should return all modified but not removed files" do
      expected_array = [
        "config/locales/de.yml",
        "config/locales/us.yml"
      ]

      hook = Hook.new(fixture("hook4.json"))
      hook.affected_files.should =~ expected_array
    end
  end

  describe "#fetch_affected_i18n_files" do
    it "should download affected i18n files from github and save them to tmp directory" do
      hook = Hook.new(fixture("hook1.json"))
      hook.should_receive(:affected_files).and_return(["README", "config/locales/en.yml", "config/application.rb", "config/locales/de.yml"])
      Github.should_receive(:fetch_raw_data).with({:user=>"vavaka", :repo=>"github-hooks-test", :branch=>"master", :path=>"config/locales/en.yml"}).and_return("123")
      Github.should_receive(:fetch_raw_data).with({:user=>"vavaka", :repo=>"github-hooks-test", :branch=>"master", :path=>"config/locales/de.yml"}).and_return("456")

      hook.should_receive(:save_to_tmp).with("config/locales/en.yml", "123")
      hook.should_receive(:save_to_tmp).with("config/locales/de.yml", "456")

      hook.fetch_affected_i18n_files
    end
  end
end

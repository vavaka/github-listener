require 'spec_helper'

describe HookController do
  describe "create" do
    it "should not create new Hook instance if payload is not specified" do
      Hook.should_not_receive(:new)

      post :create
    end

    it "should fetch affected localization files if payload specified" do
      hook = mock("hook")
      hook.should_receive(:fetch_affected_i18n_files)
      Hook.should_receive(:new).and_return(hook)

      post :create, :payload => "valid_data"
    end

    it "should handle errors during payload data parsing" do
      Hook.should_receive(:new).and_raise(ArgumentError)

      post :create, :payload => "invalid_data"
    end

    it "should handle errors during fetching affected localization files" do
      hook = mock("hook")
      hook.should_receive(:fetch_affected_i18n_files).and_raise(SocketError)
      Hook.should_receive(:new).and_return(hook)

      post :create, :payload => "valid_data"
    end
  end
end

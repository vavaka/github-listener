require 'spec_helper'

describe HookController do
  describe "POST create" do
    it "should not create new Hook instance if payload is not specified" do
      Hook.should_not_receive(:new)

      post :create
    end

    it "should handle hook if payload is specified" do
      hook = mock("hook")
      hook.should_receive(:handle)
      Hook.should_receive(:new).and_return(hook)

      post :create, :payload => "valid_data"
    end

    it "should handle errors during payload data parsing" do
      Hook.should_receive(:new).and_raise(ArgumentError)

      post :create, :payload => "invalid_data"
    end

    it "should handle errors during hook handling" do
      hook = mock("hook")
      hook.should_receive(:handle).and_raise(SocketError)
      Hook.should_receive(:new).and_return(hook)

      post :create, :payload => "valid_data"
    end
  end
end

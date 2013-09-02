require 'spec_helper'

describe Playbah do

  subject { described_class }

  let(:user_name) { "user_name" }
  let(:api_token) { "api_token" }
  let(:room_name) { "room_name" }

  def setup_playbah
    Playbah.config do |config|
      config.user_name = user_name
      config.api_token = api_token
      config.room_name = room_name
    end
  end
  def clear_playbah
    Playbah.module_eval "@config = nil"
  end

  after(:each) do
    clear_playbah
  end

  describe '.send_message' do
    let(:message) { "message" }

    it 'sends a message idea' do
      setup_playbah
      hipchat_client = double(:hipchat_client)
      room = double(:room)
      expect(HipChat::Client).to receive(:new).with(api_token).and_return(hipchat_client)
      expect(hipchat_client).to receive(:[]).with(room_name).and_return(room)
      expect(room).to receive(:send).with(user_name, message)
      subject.send_message(message)
    end
  end

  describe ".config" do
    it "setups up the config values" do
      setup_playbah
      Playbah.config.user_name.should == user_name
      Playbah.config.api_token.should == api_token
      Playbah.config.room_name.should == room_name
    end

    it "works with a configuration file" do
      settings = {
        "user_name" => user_name,
        "api_token" => api_token,
        "room_name" => room_name
      }
      File.write("./.playbah", settings.to_yaml)

      Playbah.config.user_name.should == user_name
      Playbah.config.api_token.should == api_token
      Playbah.config.room_name.should == room_name
    end
  end
end

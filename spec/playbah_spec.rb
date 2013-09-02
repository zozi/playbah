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
    File.delete('./.playbah') if File.exists?('./.playbah')
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

    it "throws a PlaybahConfigError if you try and use it without configuring it" do
      expect {
        subject.send_message("message")
      }.to raise_error(PlaybahConfigError)
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

  describe ".capture_string" do
    let(:contents) { "contents" }

    it 'creates an anonymous gist' do
      gist_url = 'html_url'
      return_hash = { "html_url" => gist_url }
      expect(Gist).to receive(:gist).with(contents, anything).and_return(return_hash)

      subject.capture_string(contents).should == gist_url
    end
  end

  describe ".capture_files" do
    let(:gist_return) { { "html_url" => gist_url } }
    let(:gist_url) { 'html_url' }
    let(:file1_contents) { "content of file 1" }
    let(:file2_contents) { "content of file 2" }

    def create_tempfile(name, content)
      file = Tempfile.new(name)
      file.write(content)
      file.close
      file
    end

    it "uploads multiple files" do
      file1 = create_tempfile('file1', file1_contents)
      file2 = create_tempfile('file2', file2_contents)
      gist_files = {
        file1.path => file1_contents,
        file2.path => file2_contents,
      }
      expect(Gist).to receive(:multi_gist).with(gist_files, anything).and_return(gist_return)

      subject.capture_files([file1.path, file2.path])
    end
  end
end

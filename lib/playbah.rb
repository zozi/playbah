require "playbah/version"
require 'hipchat'
require 'gist'

class PlaybahConfigError < StandardError; end

module Playbah
  def self.send_message(message)
    raise PlaybahConfigError unless config.is_set?
    hipchat_client = HipChat::Client.new(config.api_token)
    hipchat_client[config.room_name].send(config.user_name, message)
  end

  def self.capture_string(contents, options = {})
    gist_options = { anonymous: true }
    result = Gist.gist(contents, gist_options.merge(options))
    result["html_url"]
  end

  # files is an array of filenames
  def self.capture_files(files, options = {})
    gist_options = { anonymous: true }
    files_hash = files.inject({}) do |hash, file_path|
      file = File.open(file_path, 'rb')
      hash[file_path] = file.read
      hash
    end
    result = Gist.multi_gist(files_hash, gist_options.merge(options))
    result["html_url"]
  end


  def self.config(&block)
    @config ||= Config.new(&block)
  end

  class Config
    attr_accessor :user_name, :room_name, :api_token

    def initialize
      file_name = './.playbah'

      if block_given?
        yield self
      elsif File.exists?(file_name)
        load_from_file(file_name)
      end
    end

    def is_set?
      true if user_name && room_name && api_token
    end

    def load_from_file(file_name)
      load_from_hash(YAML::load_file(file_name))
    end

    def load_from_hash(hash)
      self.user_name = hash["user_name"]
      self.room_name = hash["room_name"]
      self.api_token = hash["api_token"]
    end
  end
end

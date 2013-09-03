require "playbah/version"
require 'playbah/capture'
require 'hipchat'

module Playbah
  class ConfigError < StandardError; end
  def self.send_message(message, options = {})
    raise ConfigError.new("Please setup the config w/ 'playbah config'") unless config.is_set?
    hipchat_options = { message_format: 'text' }
    hipchat_client = HipChat::Client.new(config.api_token)
    hipchat_client[config.room_name].send(config.user_name, message, hipchat_options.merge(options))
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

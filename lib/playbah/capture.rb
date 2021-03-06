require 'gist'
require 'digest/md5'


module Playbah
  class CaptureError < StandardError; end
  def self.capture(items, options = {})
    # Array.wrap
    items = if items.nil?
      []
    elsif items.respond_to?(:to_ary)
      items.to_ary || [items]
    else
      [items]
    end

    Capture.open(anonymous: true) do |c|
      items.each {|item| c.add(item) }
    end
  end

  class Capture
    attr_reader :files, :defaults, :result_url

    def self.open(defaults = {})
      capture = Capture.new(defaults)
      begin
        yield capture if block_given?
      rescue => ex
        raise CaptureError.new(ex.message)
      ensure
        capture.close
      end
      capture.result_url
    end

    def initialize(defaults = {})
      @defaults = defaults
      @files = {}
      @result_url = "Unset result_url"
    end

    def add(string_or_path)
      if File.exists?(string_or_path)
        add_file(string_or_path)
      else
        add_string(string_or_path)
      end
    end

    def add_string(string)
      files[Digest::MD5.hexdigest(string)] = string
    end

    def add_file(path)
      files[path] = IO.read(path)
    end

    # actually perform the capture to the remote store
    def close(options = {})
      return if files.empty?
      result = Gist.multi_gist(files, defaults.merge(options))
      @result_url = result["html_url"]
    end
  end
end



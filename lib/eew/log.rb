# frozen_string_literal: true

require 'logger'
module EEW
  class Log
    def initialize
      @logger = Logger.new($stdout)
    end

    def info(str)
      @logger.info(str)
    end

    def debug(str)
      @logger.debug(str)
    end
  end
end

# frozen_string_literal: true
require "time"

module EEW
  class HTTPHeader
    def initialize(data)
      @data = data
    end

    def length
      headers['Content-Length'].to_i
    end

    def login?
      headers['X-WNI-Result'] == 'OK'
    end

    def data?
      headers['X-WNI-ID'] == 'Data'
    end

    def data
        headers['X-WNI-ID']
    end

    def md5
      headers['X-WNI-Data-MD5']
    end

    def time
      Time.parse(headers['X-WNI-Time'] + " UTC")
    end

    def headers
      @data.split($/).drop(1).inject({}) do |h, l|
          k, v = l.split(": ", 2)
          h[k] = (v unless v.empty?)
          h
        end
    end

    def [](key)
      headers[key]
    end

    def to_h
      headers
    end
  end
end

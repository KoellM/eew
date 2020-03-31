# frozen_string_literal: true

module EEW
  class TelegramParser
    attr_reader :code, :header, :body
    def initialize(socket)
      @telegram = socket
      parse!
    end

    def parse!
      @code = parse_code.encode('UTF-8', 'SHIFT_JIS')
      @header = parse_header.encode('UTF-8', 'SHIFT_JIS')
      @body = parse_body.encode('UTF-8', 'SHIFT_JIS')
    end

    def send_res
      res_headers = {
        'Content-Type' => 'application/fast-cast',
        'User-Agent' => 'FastCaster/1.0 powered by Weathernews.',
        'X-WNI-ID' => 'Response',
        'X-WNI-Result' => 'OK',
        'X-WNI-Protocol-Version' => '2.1',
        'X-WNI-Time' => Time.now.utc.strftime('%Y/%m/%d %T.%6N')
      }
      res = "HTTP/1.1 200 OK\n#{res_headers.map { |k, v| "#{k}: #{v}" }.join("\n")}\n\n"
      @telegram.print(res)
    end

    private

    def parse_code
      @telegram.readline("\n\n").delete("\x01\n").chomp
    end

    def parse_header
      @telegram.readline("\x02\n\x02\n").delete("\x02\n").chomp
    end

    def parse_body
      @telegram.readline("\n\x03").delete("\x03").chomp
    end
  end
end

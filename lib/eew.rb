# frozen_string_literal: true

require 'socket'
require 'open-uri'
require 'eew/version'
require 'eew/http_header'
require 'eew/telegram_parser'
require 'eew/log'

module EEW
  class Authentication < StandardError; end
  # Socket 连接处理
  class Client
    # 初始化
    # @param id [String] 邮箱
    # @param password [String] MD5 密码
    # @param terminal_id [String] Terminal ID
    # @param log [Logger] Logger
    # @return [void]
    def initialize(id, password, terminal_id, log = Log.new)
      @log = log
      @id = id
      @password = password
      @terminal_id = terminal_id
      @ip, @port = get_server_list
    end

    # 连接服务器
    # @param ip [String] IP
    # @param port [String] Port
    # [yield] headers, telegram
    def connect(ip = @ip, port = @port)
      socket = TCPSocket.open(ip, port)
      socket.print(get_req)

      result = HTTPHeader.new(socket.readline("\n\n"))

      if result.login?
        @log.info("authentication success. Server: #{@ip}:#{@port}")
      else
        raise Authentication, 'authentication failed.'
      end

      while data = socket.readline("\n\n")
        headers = HTTPHeader.new(data)
        if headers.data?
          telegram = TelegramParser.new(socket)
          yield(headers, telegram)
        else
          yield(headers, nil)
        end
      end
    end

    private

    def get_server_list
      array = []
      URI.open('http://lst10s-sp.wni.co.jp/server_list.txt') do |l|
        array = l.read.lines.to_a
      end
      array.sample.chomp!.split(':')
    end

    def get_headers
      headers = {
        'Accept' => '*/*',
        'Cache-Control' => 'no-cache',
        'User-Agent' => 'FastCaster/1.0 powered by Weathernews.',
        'X-WNI-Account' => @id,
        'X-WNI-Application-Version' => '2.4.2',
        'X-WNI-Authentication-Method' => 'MDB_MWS',
        'X-WNI-ID' => 'Login',
        'X-WNI-Password' => @password,
        'X-WNI-Protocol-Version' => '2.1',
        'X-WNI-Terminal-ID' => @terminal_id,
        'X-WNI-Time' => Time.now.utc.strftime('%Y/%m/%d %T.%6N')
      }
      headers
    end

    def get_req
      "GET /login HTTP/1.1\n#{get_headers.map { |k, v| "#{k}: #{v}" }.join("\n")}\n\n"
    end
  end
end

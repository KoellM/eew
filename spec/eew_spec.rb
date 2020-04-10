RSpec.describe EEW do
  before do
    @server = "localhost"
    @port = 3001
    @server = TCPServer.new(@server, @port)
    @client = EEW::Client.new("test", "test", "0000000")
  end

  after do
    @server.close
  end

  it "has a version number" do
    expect(EEW::VERSION).not_to be nil
  end
end

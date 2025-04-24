module ActionCableHelper
  def stream_from(channel)
    # Mock for stream_from
  end

  def stop_all_streams
    # Mock for stop_all_streams
  end
end

RSpec.configure do |config|
  config.include ActionCableHelper, type: :channel
end

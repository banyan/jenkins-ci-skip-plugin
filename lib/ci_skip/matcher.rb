module CiSkip
  class Matcher
    def initialize(message)
      @message = message.to_s
    end

    def skip?
      !!(@message =~ /\[ci\s+skip\\?\]|\[skip\s+ci\\?\]/i)
    end
  end
end

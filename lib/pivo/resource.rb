module Resource
  module ApiClient
    private

    def client
      TrackerApi::Client.new(token: token)
    end

    def token
      YAML.load(File.read("#{ENV['HOME']}/.pivo.yml"))['token']
    end
  end

  class Story
    def initialize(story)
      @story = story
    end

    def to_s
      "[#{@story.estimate}][#{@story.current_state}]\t#{@story.name}\t#{@story.url}"
    end
  end
end

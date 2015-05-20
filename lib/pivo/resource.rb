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

  class Me
    include ApiClient

    def initialize
      @me = client.me
    end

    def name
      @me.name
    end
  end

  class Project
    extend ApiClient

    class << self
      def all
        client.projects
      end

      def find_by_name(name)
        client.projects.select {|project| project.name == name}[0]
      end
    end
  end

  class AcceptedStory
    def initialize(story, format_option)
      @story = story
      @format_option = format_option
    end

    def to_s
      owners = { "1468330" => "西田", "1327244" => "桐山", "1133040" => "五十嵐", "76519" => "uk", "1132876" => "堀", "1295084" => "下山", "1352110" => "南谷" }
      "#{owners[@story.owner_ids.first.to_s]} #{@story.name} #{@story.estimate.to_i}"
    end
  end

end

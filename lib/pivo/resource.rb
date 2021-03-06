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
end

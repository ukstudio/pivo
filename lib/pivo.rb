require "pivo/version"

require 'yaml'
require 'tracker_api'
require 'thor'

module Pivo
  class CLI < Thor
    desc "projects", "listing project names"
    def projects
      say client.projects.map(&:name).join("\n")
    end

    desc "stories PROJECT_NAME", "listing project stories"
    def stories(project_name)
      project = client.projects.select {|project| project.name == project_name}[0]
      project.stories.each do |story|
        say "[#{story.current_state}] #{story.name}"
      end
    end

    private

    def client
      TrackerApi::Client.new(token: token)
    end

    def token
      YAML.load(File.read("#{ENV['HOME']}/.pivo.yml"))['token']
    end
  end
end

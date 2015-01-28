require "pivo/version"

require 'yaml'
require 'tracker_api'
require 'thor'

module Pivo
  module ApiClient
    private

    def client
      TrackerApi::Client.new(token: token)
    end

    def token
      YAML.load(File.read("#{ENV['HOME']}/.pivo.yml"))['token']
    end
  end

  class Stories < Thor
    include ApiClient
    
    desc "stories all PROJECT_NAME", "listing all stories"
    def all(project_name)
      project = client.projects.select {|project| project.name == project_name}[0]
      project.stories.each do |story|
        say "[#{story.current_state}]\t#{story.name}\t#{story.url}"
      end
    end

    desc "stories me PROJECT_NAME", "listing my stories"
    def me(project_name)
      me = client.me
      project = client.projects.select {|project| project.name == project_name}[0]
      project.stories(filter: "mywork:\"#{me.name}\"").each do |story|
        say "[#{story.current_state}]\t#{story.name}\t#{story.url}"
      end
    end
  end

  class CLI < Thor
    include ApiClient

    desc "projects", "listing project names"
    def projects
      say client.projects.map(&:name).join("\n")
    end

    desc "stories PROJECT_NAME", "listing project stories"
    def stories(project_name)
      project = client.projects.select {|project| project.name == project_name}[0]
      project.stories.each do |story|
        say "[#{story.current_state}]\t#{story.name}\t#{story.url}"
      end
    end

    desc "stories SUBCOMMAND ARGS", "listing stories"
    subcommand "stories", Stories
  end
end

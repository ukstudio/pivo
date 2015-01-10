require "pivo/version"

require 'yaml'
require 'tracker_api'
require 'thor'

module Pivo
  class CLI < Thor
    desc "projects", "listing project names"
    def projects
      token =  YAML.load(File.read("#{ENV['HOME']}/.pivo.yml"))['token']
      client = TrackerApi::Client.new(token: token)
      puts client.projects.map(&:name).join("\n")
    end
  end
end

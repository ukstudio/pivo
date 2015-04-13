require 'yaml'
require 'tracker_api'
require 'thor'
require 'date'

require 'pivo/resource'
require 'pivo/formatters'

module Pivo
  class Stories < Thor
    desc "all PROJECT_NAME", "listing all stories"
    option :status, type: 'string', desc: "unscheduled, unstarted, planned, rejected, started, finished, delivered, accepted"
    option :format, type: 'string', desc: "default, md"
    def all(project_name)
      project = Resource::Project.find_by_name(project_name)
      filtering_options = {}
      filtering_options.merge!(with_state: options[:status]) if options[:status]
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(project.stories(filtering_options)).to_s
      else
        say Formatters::Stories::Default.new(project.stories(filtering_options)).to_s
      end
    end

    desc "me PROJECT_NAME", "listing my stories"
    option :status, type: 'string', desc: "unscheduled, unstarted, planned, rejected, started, finished, delivered, accepted"
    option :format, type: 'string', desc: "default, md"
    def me(project_name)
      me = Resource::Me.new
      project = Resource::Project.find_by_name(project_name)
      filtering_options = {}
      filtering_options.merge!(filter: "state:#{options[:status]} owner:\"#{me.name}\"")
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(project.stories(filtering_options)).to_s
      else
        say Formatters::Stories::Default.new(project.stories(filtering_options)).to_s
      end
    end

    desc "accepted PROJECT_NAME", "listing accepted stories"
#    option :status, type: 'string', desc: "unscheduled, unstarted, planned, rejected, started, finished, delivered, accepted"
    option :format, type: 'string', desc: "default, md"
    option :from, type: 'string', desc: "example: 2015-05-01"
    option :to, type: 'string', desc: "example: 2015-05-08"

    def accepted(project_name)
      project = Resource::Project.find_by_name(project_name)
      filtering_options = {}
      filtering_options.merge!(with_state: "accepted")
      from = options[:from].split('-').map(&:to_i) #=> example: ["2015", "03", "01"]
      to = options[:to].split('-').map(&:to_i)
      filtering_options.merge!(accepted_after: DateTime.new(*from).iso8601)
      filtering_options.merge!(accepted_before: DateTime.new(*to).iso8601)
      stories = project.stories(filtering_options)
      stories.sort_by{|s| s.owner_ids.first.to_i }.each do |story|
        say Resource::AcceptedStory.new(story, (options[:format] || 'default')).to_s
      end
    end
  end

  class CLI < Thor
    desc "projects", "listing project names"
    def projects
      say Resource::Project.all.map(&:name).join("\n")
    end

    desc "stories PROJECT_NAME", "listing project stories"
    def stories(project_name)
      project = Resource::Project.find_by_name(project_name)
      say Formatters::Stories::Default.new(project.stories(filtering_options)).to_s
    end

    desc "stories SUBCOMMAND ARGS", "listing stories"
    subcommand "stories", Stories
  end
end

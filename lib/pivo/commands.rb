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
    option :mywork, type: 'string', desc: "listing mywork storeis of the specified user"
    option :format, type: 'string', desc: "default, md"
    def all(project_name)
      project = Resource::Project.find_by_name(project_name)
      filtering_options = []
      filtering_options << "state:#{options[:status]}" if options[:status]
      if options[:mywork]
        filtering_options << "mywork:#{options[:mywork]}" if options[:mywork]
      end
      options = filtering_options.empty? ? {} : {filter: filtering_options.join(" ")}
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(project.stories(options)).to_s
      else
        say Formatters::Stories::Default.new(project.stories(options)).to_s
      end
    end

    desc "iteration PROJECT_NAME", "listing stories of iteration"
    option :iterationnumber, type: 'numeric', default: 0, desc: "current iteration number = 0, prev iterationn number = 1, prev prev = 2..."
    option :format, type: 'string', desc: "default, md"
    def iteration(project_name)
      project = Resource::Project.find_by_name(project_name)
      iteration_number = project.current_iteration_number
      iteration_number -= options[:iterationnumber] if options[:iterationnumber]
      iteration = project.iterations(number: iteration_number).first
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(iteration.stories).to_s
      else
        say Formatters::Stories::Default.new(iteration.stories).to_s
      end
    end

    desc "me PROJECT_NAME", "listing my stories"
    option :status, type: 'string', desc: "unscheduled, unstarted, planned, rejected, started, finished, delivered, accepted"
    option :format, type: 'string', desc: "default, md"
    def me(project_name)
      me = Resource::Me.new
      project = Resource::Project.find_by_name(project_name)
      filtering_options = {}
      filtering_options.merge!(filter: "state:#{options[:status]} mywork:\"#{me.name}\"")
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(project.stories(filtering_options)).to_s
      else
        say Formatters::Stories::Default.new(project.stories(filtering_options)).to_s
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

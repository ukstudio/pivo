require 'yaml'
require 'tracker_api'
require 'thor'
require 'date'

require 'pivo/resource'
require 'pivo/formatters'

module Pivo
  class Stories < Thor
    desc "all PROJECT_NAME", "listing all stories"
    option :query, type: 'string',  desc: "query for searching stories"
    option :format, type: 'string', desc: "default, md, kanban"
    def all(project_name)
      project = Resource::Project.find_by_name(project_name)
      filtering_options = []
      filtering_options << options[:query] if options[:query]
      request_params = filtering_options.empty? ? {} : {filter: filtering_options.join(" ")}
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(project.stories(request_params)).to_s
      when 'md-table'
        say Formatters::Stories::MarkdownTable.new(project.stories(request_params)).to_s
      when 'kanban'
        say Formatters::Stories::Kanban.new(project.stories(request_params)).to_s
      else
        say Formatters::Stories::Default.new(project.stories(request_params)).to_s
      end
    end

    desc "add PROJECT_NAME", "create new story"
    option :name, type: 'string', desc: "new story's name", required: true
    option :description, type: 'string', desc: "new story's description", default: ""
    def add(project_name)
      project = Resource::Project.find_by_name(project_name)
      story = project.create_story(name: options[:name], description: options[:description])
      say story.url
    end

    desc "iteration PROJECT_NAME", "listing stories of iteration"
    option :iterationnumber, type: 'numeric', default: 0, desc: "current iteration number = 0, prev iterationn number = 1, prev prev = 2..."
    option :format, type: 'string', desc: "default, md, kanban"
    def iteration(project_name)
      project = Resource::Project.find_by_name(project_name)
      iteration_number = project.current_iteration_number
      iteration_number -= options[:iterationnumber] if options[:iterationnumber]
      iteration = project.iterations(number: iteration_number).first
      case options[:format]
      when 'md'
        say Formatters::Stories::Markdown.new(iteration.stories).to_s
      when 'md-table'
        say Formatters::Stories::MarkdownTable.new(iteration.stories).to_s
      when 'kanban'
        say Formatters::Stories::Kanban.new(iteration.stories).to_s
      else
        say Formatters::Stories::Default.new(iteration.stories).to_s
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

require 'yaml'
require 'tracker_api'
require 'thor'
require 'date'

require 'pivo/resource'

module Pivo
  class Velocity < Thor
    desc "velocity me PROJECT_NAME VELOCITY", "listing my stories each velocity"
    def me(project_name, velocity)
      me = Resource::Me.new
      project = Resource::Project.find_by_name(project_name)
      stories = project.stories(filter: "owner:\"#{me.name}\"")

      days = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
      week_start_day = project.week_start_day
      index_of_start_day = days.index(week_start_day)
      current_day = DateTime.now.wday
      diff = current_day-index_of_start_day
      diff = 7 - diff if diff < 0

      current_iteration_start_date = DateTime.now - diff

      point = 0
      iteration_index = 1
      say "\n===#{current_iteration_start_date.strftime('%Y-%m-%d %a')}=========================================================================\n\n"
      stories.each do |story |
        if point + story.estimate > velocity.to_i
          say "total point: #{point}"
          say "\n===#{(current_iteration_start_date + iteration_index*7).strftime('%Y-%m-%d %a')}=========================================================================\n\n"
          iteration_index += 1
          point = story.estimate
        else
          point += story.estimate
        end
        say Resource::Story.new(story).to_s
      end
    end
  end

  class Stories < Thor

    desc "all PROJECT_NAME", "listing all stories"
    option :status, type: 'string', desc: "unscheduled, unstarted, planned, rejected, started, finished, delivered, accepted"
    option :format, type: 'string', desc: "default, md"
    def all(project_name)
      project = Resource::Project.find_by_name(project_name)
      filtering_options = {}
      filtering_options.merge!(with_state: options[:status]) if options[:status]
      project.stories(filtering_options).each do |story|
        say Resource::Story.new(story, (options[:format] || 'default')).to_s
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
      project.stories(filtering_options).each do |story|
        say Resource::Story.new(story, (options[:format] || 'default')).to_s
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
      project.stories.each do |story|
        say Resource::Story.new(story).to_s
      end
    end

    desc "stories SUBCOMMAND ARGS", "listing stories"
    subcommand "stories", Stories

    desc "velocity SUBCOMMAND ARGS", "listing stories each velocity"
    subcommand "velocity", Velocity
  end
end

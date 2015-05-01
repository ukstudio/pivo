require 'kosi'

module Pivo
  module Formatters
    module Stories
      class Kanban
        def initialize(stories)
          @stories = stories
          @rows    = []
        end

        def to_s
          kanban = {
            todo:  { point: 0, stories: [] },
            doing: { point: 0, stories: [] },
            done:  { point: 0, stories: [] }
          }

          @stories.each do |story|
            row = Array.new(3, '')
            key = category(story)
            kanban[key][:point] += story.estimate.to_i
            kanban[key][:stories] << story
          end

          collect!(kanban)
          @rows << [kanban[:todo][:point], kanban[:doing][:point], kanban[:done][:point]]

          kosi = Kosi::Table.new(align: Kosi::Align::TYPE::LEFT, header: ['ToDo', 'Doing', 'Done'])
          kosi.render @rows
        end

        private

        def category(story)
          case story.current_state
          when 'unscheduled', 'unstarted', 'planned'
            :todo
          when 'started', 'finished', 'delivered'
            :doing
          when 'rejected', 'accepted'
            :done
          end
        end

        def collect!(kanban)
          todo  = kanban[:todo][:stories].shift
          doing = kanban[:doing][:stories].shift
          done  = kanban[:done][:stories].shift

          if todo.nil? && doing.nil? && done.nil?
            return
          end

          col = -> (story) { "[#{story.estimate.to_i}]#{story.name}" }

          @rows << [todo ? col.call(todo): '', doing ? col.call(doing): '', done ? col.call(done) : '']
          collect!(kanban)
        end
      end
    end
  end
end

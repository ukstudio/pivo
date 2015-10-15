module Pivo
  module Formatters
    module Stories
      class MarkdownTable
        def initialize(stories)
          @stories = stories
          @stories_group_by_owner = {}
        end

        def to_s
          @stories.each do |story|
            if story.owner_ids.empty?
              @stories_group_by_owner['no owner'] ||= initial_hash
              @stories_group_by_owner['no owner'][category(story)] << story
            else
              story.owner_ids.each do |owner_id|
                @stories_group_by_owner[owner_id] ||= initial_hash
                @stories_group_by_owner[owner_id][category(story)] << story
              end
            end
          end

          table = <<-TABLE
| Member | ToDo | Doing | Done |
|--------|------|-------|------|
          TABLE

          @stories_group_by_owner.each do |owner_id, categories|
            table += "| #{owner_id} | #{stories_to_s(categories[:todo])} | #{stories_to_s(categories[:doing])} | #{stories_to_s(categories[:done])} |\n"
          end

          table
        end

        private

        def stories_to_s(stories)
          stories.map(&:name).join("<br>")
        end

        def initial_hash
          {
            todo: [],
            doing: [],
            done: []
          }
        end

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
      end
    end
  end
end

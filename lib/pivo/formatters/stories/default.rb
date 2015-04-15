module Pivo
  module Formatters
    module Stories
      class Default
        def initialize(stories)
          @stories = stories
        end

        def to_s
          @stories.map {|story|
            "[#{story.estimate}][#{story.current_state}]\t#{story.name}\t#{story.url}"
          }.join("\n")
        end
      end
    end
  end
end

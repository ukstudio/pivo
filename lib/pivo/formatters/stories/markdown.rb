module Pivo
  module Formatters
    module Stories
      class Markdown
        def initialize(stories)
          @stories = stories
        end

        def to_s
          @stories.map {|story|
            "[#{story.estimate}][#{story.name}](#{story.url})"
          }.join("\n")
        end
      end
    end
  end
end

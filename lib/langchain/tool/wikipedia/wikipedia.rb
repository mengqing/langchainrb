# frozen_string_literal: true

module Langchain::Tool
  class Wikipedia < Base
    #
    # Tool that adds the capability to search using the Wikipedia API
    #
    # Gem requirements:
    #     gem "wikipedia-client", "~> 1.17.0"
    #
    # Usage:
    #     weather = Langchain::Tool::Wikipedia.new
    #     weather.execute(input: "The Roman Empire")
    #
    NAME = "wikipedia"
    ANNOTATIONS_PATH = Langchain.root.join("./langchain/tool/#{NAME}/#{NAME}.json").to_path

    description <<~DESC
      A wrapper around Wikipedia.

      Useful for when you need to answer general questions about
      people, places, companies, facts, historical events, or other subjects.

      Input should be a search query.
    DESC

    # Initializes the Wikipedia tool
    def initialize
      depends_on "wikipedia-client", req: "wikipedia"
    end

    # Executes Wikipedia API search and returns the answer
    #
    # @param input [String] search query
    # @return [String] Answer
    def execute(input:)
      Langchain.logger.info("Executing \"#{input}\"", for: self.class)

      page = ::Wikipedia.find(input)
      # It would be nice to figure out a way to provide page.content but the LLM token limit is an issue
      page.summary
    end
  end
end

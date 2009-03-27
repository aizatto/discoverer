module DiscoveryParser
  class Parser
    attr_reader :discoverer, :images, :uri, :url, :response

    def initialize(discoverer)
      @discoverer, @uri, @url, @response = discoverer, discoverer.uri, discoverer.url, discoverer.response
      @images = []
    end
  end
end

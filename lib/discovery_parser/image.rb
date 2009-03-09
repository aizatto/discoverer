module DiscoveryParser
  class Image < ::DiscoveryParser::Parser
    attr_reader :images, :videos, :discoverer

    # As it is an image, we do not need to:
    #  * search for images
    #  * search for videos
    def initialize(discoverer)
      super(discoverer)
      @images = [@discoverer.url]
    end
  end
end

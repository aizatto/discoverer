# For discovering thumbnails, Facebook has published a method for sites
# to follow to ease the selection of choosing a thumbnail.
#   http://www.facebook.com/share_partners.php
#
# Likewise Digg follows the same procedure for discovering thumbnails, 
# though it is similar to Facebook.
#   http://digg.com/tools/thumbnails
module DiscoveryParser
  class HTML < ::DiscoveryParser::Parser
    DISCOVERY_METHODS = []

    attr_reader :doc, :name, :description, :discovered_thumbnail

    def absolute_image_path(image_path)
      return image_path if image_path.nil? || image_path =~ /^http(s)?:\/\//

      prefix = "#{uri.scheme}://#{uri.host}"
      image_path[0..0] == '/' ? "#{prefix}#{image_path}" : "#{prefix}#{uri.request_uri}#{image_path}"
    end

    def initialize(discoverer)
      super(discoverer)
      @doc = Hpricot(response.body)
    end      

    def parse
      filter
      discover
    end

    protected
      # We strip javascript second, as javascript can
      # be used to embed flash videos into the page.
      def filter
        filter_video
        (@doc/"script").remove
        filter_images
      end
      
      def filter_images
        @images += (@doc/"img").collect do |tag|
          next unless tag.has_attribute? 'src'

          absolute_image_path(tag['src'])
        end.uniq
      end

      # TODO
      def filter_video
      end

      def discover
        dm = select_discovery_method.new(self, @doc)
        @name        = dm.discover_name
        @description = dm.discover_description
        @image_url   = absolute_image_path(dm.discover_thumbnail)

        # if an image was discovered, we will put it at the front of the array
        @images.unshift(@image_url) unless @image_url.nil?
      end

      def select_discovery_method
        ::DiscoveryParser::HTML::DISCOVERY_METHODS.find { |klass| @url =~ klass::SELECTOR_REGEX }
      end
  end
end

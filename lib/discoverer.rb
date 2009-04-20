%w[discovery_parser/parser discovery_parser/html discovery_method/standard discovery_parser/image].each do |file|
  require File.join(File.dirname(__FILE__), file)
end

class Discoverer
  class InvalidURIScheme < StandardError
  end

  attr_reader :name, :description, :image_url, :parser
  attr_reader :images, :videos, :filtered, :discovered_thumbnail, :response, :parser
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def uri
    URI.parse(@url)
  end

  def valid_uri_scheme?(url)
    url =~ /^http:\/\//
  end

  def valid_response_code?(response_code)
    response_code == "200"
  end

  def filter
    return if @filtered

    raise InvalidURIScheme unless valid_uri_scheme?(self.url)
    get_response

    parser = case @response.content_type
    when "text/html"                            then ::DiscoveryParser::HTML
    when "image/gif", "image/jpeg", "image/png" then ::DiscoveryParser::Image
    end

    @parser = parser.new(self)
    @parser.parse

    @filtered = true
  end

  def assign_defaults
    case @parser
    when ::DiscoveryParser::HTML
      @name        = @parser.name
      @description = @parser.description
      @image_url   = @parser.images.first
    when ::DiscoveryParser::Image
      @image_url = @parser.images.first
    end
  end

  def select_image(image_url)
    return if image_url.blank?
    filter

    return unless @parser.images.include? image_url

    image_uri     = URI.parse(image_url)
    image_content = case @parser

    when ::DiscoveryParser::HTML
      image_response = Net::HTTP.get_response(image_uri)
      return unless valid_response_code? image_response.code

      case image_response.content_type
      when "image/gif", "image/jpeg", "image/png"
        image_response.body
      else
        return
      end
    when ::DiscoveryParser::Image
      @response.body
    end

    stringio = StringIO.new(image_content)
    stringio.original_filename = File.basename(image_uri.path)

    return stringio
  end

  def images
    @parser.images
  end

  protected
    def get_response
      @response = Net::HTTP.get_response(URI.parse(url))
      raise InvalidHTTPResponse unless valid_response_code?(@response.code)
    end

    def image_exists_from_source
      return unless image_file_name_changed?
      @images
    end
end

# Generates a thumbnail to an image and renders an image tag.
# The image will be resized to fit within a max bounding box.
# The resulting filename is based on original and includes dimensions.
# All paths are relative to /source.
#
# If you are running under octopress in preview mode, we generate images that scale the original
# if a new thumbnail is needed. This prevents the server from descending into an
# infinite thumbnail and detection loop.
# 
# Usage:
# 
# {% thumbnail /path/to/local/image.png 50x50< %}
#
# The dimensions will be given directly to imagemagick.
# You probably want the "<" at the end. See http://www.imagemagick.org/Magick++/Geometry.html.
#
# Installation:
# 
# * add the gem: gem "mini_magick" (and bundle install)
# * copy thumbnail.rb to plugins folder
require 'mini_magick'

class Jekyll::Thumbnail < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    if /(?<source>[^\s]+)\s+(?<dimensions>[^\s]+)/i =~ markup
      @source = source
      @dimensions = dimensions
    end
    super
  end

  def render(context)
    if @source

      # parking
      source = @source
      dimensions = @dimensions

      source_path = "./source#{source}"
      raise "#{source} is not readable" unless File.readable?(source_path)
      ext = File.extname(source)
      desc = dimensions.gsub(/[^\da-z]+/i, '')
      dest = "#{File.dirname(source)}/#{File.basename(source, ext)}_#{desc}#{ext}"
      dest_path = "./source#{dest}"

      # only thumbnail the image if it doesn't exist tor is less recent than the source file
      # will prevent re-processing thumbnails for a ton of images...
      if !File.exists?(dest_path) || File.mtime(dest_path) <= File.mtime(source_path)
        # puts ENV.inspect

        # don't generate images in preview mode whenever possible
        if ENV['OCTOPRESS_ENV'] == 'preview' && /(?<width>\d+)?x(?<height>\d+)?/ =~ dimensions
          html = "<img src='#{source}' style='"
          html << "max-width: #{width}px; " unless width.nil? || width.empty?
          html << "max-height: #{height}px;" unless height.nil? || height.empty?
          html << "' />"
          return html
        end

        puts "Thumbnailing #{source} to #{dest} (#{dimensions})"

        image = MiniMagick::Image.open(source_path)
        image.strip
        image.resize dimensions
        image.write dest_path
      end

      """<img src='#{dest}' />"""

      # TODO support relative paths
    else
      "Could not create thumbnail for #{source}. Usage: thumbnail /path/to/local/image.png 50x50<"
    end
  end
end



Liquid::Template.register_tag('thumbnail',   Jekyll::Thumbnail)

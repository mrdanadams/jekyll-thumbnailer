# Image thumbnailing plugin for Jekyll / octopress

Generates a thumbnail to an image and renders an image tag.

## Usage

```
{% thumbnail /path/to/local/image.png 50x50< %}
```

The dimensions will be given directly to imagemagick.
You probably want the "<" at the end. See http://www.imagemagick.org/Magick++/Geometry.html.

## Installation

* add the gem: `gem "mini_magick"` (and `bundle install`)
* copy thumbnail.rb to plugins folder
* start thumbnailing


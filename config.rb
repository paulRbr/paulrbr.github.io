###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

###
# Renderers
###
require "lib/renderers.rb"
set :renderer, AnchorHeaderRenderer

###
# Helpers
###
require "lib/helpers.rb"
helpers DateHelpers

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

###
# Blogging
###

activate :blog do |b|
  b.permalink = "{year}/{month}/{title}.html"
  b.tag_template = "tag.html"
  b.calendar_template = "calendar.html"
  b.sources = "blog/{year}-{month}-{day}-{title}.html"
  b.layout = "article"
  b.paginate = true
end

###
# Search
###

activate :search do |search|
  search.resources = ["blog/"]
  search.fields = {
    title: {boost: 100, store: true, required: true},
    content: {boost: 50},
    url: {index: false, store: true},
    author: {boost: 30},
  }
end

set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"
set :fonts_dir, "fonts"

set :markdown_engine, :kramdown
activate :syntax # , line_numbers: true

activate :sprockets

# Ignore some source files
ignore "/sortie/.git"

# Reload the browser automatically whenever files change
configure :development do
  set :site_url, "http://127.0.0.1:4567"
  set :websocket_url, "ws://127.0.0.1:9292/status"

  activate :livereload
  activate :disqus do |d|
    d.shortname = nil # Dont use production shortname in dev
  end
end
# Build-specific configuration
configure :build do
  set :build_dir, "public"
  set :base_url, "" # baseurl for GitLab Pages (project name) - leave empty if you're building a user/group website
  set :site_url, "https://paulrbr.io"
  set :websocket_url, "wss://paulrbr.io/status"
  activate :relative_assets # Use relative URLs
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Minify HTML
  activate :minify_html

  activate :disqus do |d|
    # using a different shortname for production builds
    d.shortname = "paul-bonaud-fr"
  end

  # Enable cache buster
  # activate :asset_hash do |asset_hash|
  #   asset_hash.exts << '.json'
  # end

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

# Ugly bug between Middleman and Rack 2.1.0
class ZapContentLength < Struct.new(:app)
  def call(env)
    s, h, b = app.call(env)
    # The URL rewriters in Middleman do not update Content-Length correctly,
    # which makes Rack-Lint flag the responses as having a wrong Content-Length.
    # For building assets this has zero importance because the Content-Length
    # header will be discarded - it is the server that recomputes it. But
    # it does prevent the site from building correctly.
    #
    # The fastest way out of this is to let Rack recompute the Content-Length
    # forcibly, for every response, at retrieval time.
    #
    # See https://github.com/middleman/middleman/issues/2309
    # and https://github.com/rack/rack/issues/1472
    h.delete("Content-Length")
    [s, h, b]
  end
end

app.use ::Rack::ContentLength
app.use ZapContentLength

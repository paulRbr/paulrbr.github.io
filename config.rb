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
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

###
# Helpers
###
require "lib/helpers/date_helpers"
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
  search.resources = ['blog/']
  search.fields = {
    title:   {boost: 100, store: true, required: true},
    content: {boost: 50},
    url:     {index: false, store: true},
    author:  {boost: 30}
  }
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir,  'fonts'

set :markdown_engine, :kramdown
activate :syntax #, line_numbers: true

activate :sprockets

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  activate :disqus do |d|
    d.shortname = nil # Dont use production shortname in dev
  end
end
# Build-specific configuration
configure :build do
  set :build_dir, 'public'
  set :base_url, "" # baseurl for GitLab Pages (project name) - leave empty if you're building a user/group website
  set :site_url, 'http://paul.bonaud.fr'
  activate :relative_assets # Use relative URLs
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

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

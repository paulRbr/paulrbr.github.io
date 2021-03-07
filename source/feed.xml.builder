xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Paulrbr's small space in the wild Internet"
  xml.subtitle "Blogging about my software discoveries and curiosities"
  xml.id URI.join(config[:site_url], blog.options.prefix.to_s)
  xml.link "href" => URI.join(config[:site_url], blog.options.prefix.to_s)
  xml.link "href" => URI.join(config[:site_url], current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name "PaulRbR" }

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(config[:site_url], article.url)
      xml.id URI.join(config[:site_url], article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name "PaulRbR" }
      # xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end

require "middleman-core/renderers/kramdown"

class ::Middleman::Renderers::MiddlemanKramdownHTML
  def convert_header(el, indent)
    attr = el.attr.dup
    if @options[:auto_ids] && !attr['id']
      attr['id'] = generate_id(el.options[:raw_text])
    end
    @toc << [el.options[:level], attr['id'], el.children] if attr['id'] && in_toc?(el)
    level = output_header_level(el.options[:level])

    icon = format_as_block_html("i", { class: "fa fa-link" }, "", 0)
    link_icon = format_as_block_html("a", { href: "##{attr['id']}", class: "anchor" }, icon, 0)
    inner = link_icon + inner(el, indent)
#    "<h%s id=\"%s\"><a href=\"#%s\" class=\"anchor\"><i class=\"fa fa-link\"></i></a>%s</h%s>" % [level, attr['id'], attr['id'], inner(el, indent), level]
    format_as_block_html("h#{level}", attr, inner, indent)
  end
end

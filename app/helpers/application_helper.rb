module ApplicationHelper
  def link_to_active(name, path, options={}, &block)
    options[:class] += " active" if current_page?(path)
    link_to name, path, options, &block
  end

  def image_tag_with_credit(credit, img, args)
    image_tag img, args
    #content_tag do
    #end
    #<% raise "Missing variant in image partial" unless local_assigns[:variant] %>
    #<% variant_settings = Image::VARIANTS[variant] %>
    #<div style="width: fit-content;">
    #  <%= image_tag image_variant_path(image, variant), width: variant_settings[:width], height: variant_settings[:height], style: "max-width: 100vw; height: auto;" %>
    #  <% unless image.author.blank? %>
    #    <div style="text-align: center;">
    #      <% if image.source.blank? %>
    #        <i>Crédit photo: <%= image.author %></i>
    #      <% else %>
    #        <i>Crédit photo: </i><u><%= link_to image.author, image.source, style: "color:black; font-size:0.95em;" %></u>
    #      <% end %>
    #    </div>
    #  <% end %>
    #<
  end
end

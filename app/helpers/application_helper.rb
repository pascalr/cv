module ApplicationHelper
  def link_to_active(name, path, options={}, &block)
    options[:class] += " active" if current_page?(path)
    link_to name, path, options, &block
  end

  def get_locale
    return (params[:locale] || :fr).to_sym # FIXME: Define constant elsewhere
  end

  def in_english?
    return get_locale == :en
  end

  def en_francais?
    return get_locale == :fr
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

  # Give the translated text for the key given
  def tr(key)

    # ENGLISH
    english = {
      navbar_prog: 'Programming',
      navbar_robot: 'Robotics',
      navbar_conception: 'Conception',
      navbar_projects: 'Projects',
      navbar_trips: 'Trips',
      welcome_message: '<b>Hello</b>, I am Pascal, a self-taught <b>programmer</b> with varied interests, like ' + (link_to "programming", prog_path) + ', ' + (link_to "robotics", robot_path) + ', ' + (link_to "travel", trips_path) + ', ' + (link_to "mechanical conception", conception_path) + ' and guitar!',
    }

    # FRENCH
    french = {
      navbar_prog: 'Programmation',
      navbar_robot: 'Robotiques',
      navbar_conception: 'Conception',
      navbar_projects: 'Projets',
      navbar_trips: 'Voyages',
      welcome_message: "<b>Salut</b>, je m'appelle Pascal. Je suis un <b>programmeur</b> autodidacte avec de multiples intérêts, comme la " + (link_to "programmation", prog_path) + ', la ' + (link_to "robotique", robot_path) + ', le ' + (link_to "voyage", trips_path) + ', la ' + (link_to "conception mécanique", conception_path) + ' et la guitare!',
    }

    text = in_english? ? english[key.to_sym] : french[key.to_sym]
    raise 'Translation missing; Key: '+key.to_s+'; Locale: '+get_locale.to_s unless text
    text.html_safe
  end
end

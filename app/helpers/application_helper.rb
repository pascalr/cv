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

  def link_with_icon_to(label, link)
    link_to link do
      (label + image_tag('link.svg', style: 'margin: 0 0 0.2em 0.1em')).html_safe
      #content_tag('span', class: 'd-inline-flex align-items-center') do
      #  (content_tag('span', label) + image_tag('link.svg')).html_safe
      #end
    end
  end

  def timeline_item(date, title, item=nil)
    @is_left = true unless defined?(@is_left)
    r = ''
    r += "<div class='timeline-item-"+(@is_left ? 'left' : 'right')+"'>"
    r += "  <div class='timeline-line'></div>"
    r += "  <div class='timeline-dash'></div>"
    r += "  <div class='timeline-desc'>"
    r += "    <div><b>"+date+"</b></div>"
    r += "    <div>"+title+"</div>"
    r += "  </div>"
    r += "</div>"
    @is_left = !@is_left
    return r.html_safe
  end

  def image_tag_with_credit(credit, img, args)
    image_tag img, args.merge(title: 'Credit: '+credit)
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

  def print_job(title, name, descriptions)
    r = ''
    r += '<div><b>'+title+'</b></div>'
    r += '<div style="color: grey;">'+name+'</div>'
    r += '<ul>'
    descriptions.each do |desc|
      r += '<li>'+desc+'</li>'
    end
    r += '</ul>'
    r.html_safe
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
      navbar_about: 'About',
      navbar_contact: 'Contact',
      navbar_tools: 'Tools',
      welcome_message: '<b>Hello</b>, I am Pascal, a self-taught <b>full-stack developer</b> with varied interests, like ' + (link_with_icon_to "programming", prog_path) + ', ' + (link_with_icon_to "robotics", robot_path) + ', ' + (link_with_icon_to "travel", trips_path) + ', ' + (link_with_icon_to "mechanical conception", conception_path) + ' and guitar!',
      job_title_tld: 'MECHANICAL ENGINEERING INTERN',
      job_desc_tld_1: 'Design new parts and assemblies for a machine prototype',
      job_desc_tld_2: 'Cooperate with production to clarify installation instructions',
      job_desc_tld_3: 'Draw and modify mechanical plans',
      job_name_farm: 'FAMILY FARM',
      job_title_farm: 'FARMER',
      job_desc_farm_1: 'Repair and maintain farming equipment',
      job_desc_farm_2: 'Build farm buildings integrally',
      job_desc_farm_3: 'Drive tractors and operate farming machinery',
      job_title_hopper: 'FULL STACK DEVELOPER',
      job_desc_hopper_1: "Program a system to search and analyze millions of flights",
      job_desc_hopper_2: 'Use Ruby on Rails, Java, NoSQL, MapReduce and SQLite',
      job_desc_hopper_3: "Program tests to ensure system's stability",
      job_name_ppd: 'GROUP PPD UHMW',
      job_title_ppd: 'ELECTROMECHANIC',
      job_desc_ppd_1: 'Modify programming logic controllers code (Ladder)',
      job_desc_ppd_2: 'Manipulate and configure an industrial Kuka robot',
      job_desc_ppd_3: 'Fix electrical, mechanical and hydraulic systems',
      exp_node: 'Programming back-end in javascript with multiple librairies like Express.js.',
      exp_rails: 'Programming back-end RESTful, handling databases, MVC framework.',
      exp_react: 'Programming UI in javascript with React.js or vanilla javascript.',
      exp_css: 'Design front end with CSS and HTML. Familiar with Bootstrap library.',
      exp_cpp: 'Programming low level C/C++. Coding for Arduino microcontroller and video game conception.',
      exp_godot: 'Programming a robotic arm simulation with Godot software.',
      title_prog: 'PROGRAMMING EXPERIENCE',
      title_exp: 'PROFESSIONAL EXPERIENCE',
      title_employers: 'PREVIOUS EMPLOYERS',
      contact_text: "For any questions or comments, you can contact me at the email address below:",
      contact_title: "Get in touch",
      btn_copy: "Copy",
    }

    # FRENCH
    french = {
      navbar_prog: 'Programmation',
      navbar_robot: 'Robotiques',
      navbar_conception: 'Conception',
      navbar_projects: 'Projets',
      navbar_trips: 'Voyages',
      navbar_about: 'À propos',
      navbar_contact: 'Me contacter',
      navbar_tools: 'Outils',
      welcome_message: "<b>Salut</b>, je m'appelle Pascal. Je suis un <b>programmeur full-stack</b> autodidacte avec multiples intérêts, comme la " + (link_with_icon_to "programmation", prog_path) + ', la ' + (link_with_icon_to "robotique", robot_path) + ', le ' + (link_with_icon_to "voyage", trips_path) + ', la ' + (link_with_icon_to "conception mécanique", conception_path) + ' et la guitare!',
      job_title_tld: 'STAGIAIRE EN GÉNIE MÉCANIQUE',
      job_desc_tld_1: 'Concevoir de nouvelles pièces et assemblages pour une machine prototype',
      job_desc_tld_2: 'Coopérer avec la production pour clarifier les instructions d’installations',
      job_desc_tld_3: 'Générer et modifier des plans mécaniques',
      job_name_farm: 'FERME FAMILIALE',
      job_title_farm: 'AGRICULTEUR',
      job_desc_farm_1: 'Réparer et entretenir des équipements agricoles',
      job_desc_farm_2: 'Construire des bâtiments de ferme intégralement',
      job_desc_farm_3: 'Conduire des tracteurs et opérer de la machinerie',
      job_title_hopper: 'PROGRAMMEUR FULL STACK',
      job_desc_hopper_1: "Programmer un système pour rechercher et analyser des millions de vols d'avions",
      job_desc_hopper_2: 'Employer les technologies Ruby on Rails, Java, NoSQL, MapReduce et SQLite',
      job_desc_hopper_3: 'Programmer des tests pour s’assurer de la stabilité du système',
      job_name_ppd: 'GROUPE PPD UHMW',
      job_title_ppd: 'ÉLECTROMÉCANICIEN',
      job_desc_ppd_1: 'Modifier la programmation d’automates programmables (Ladder)',
      job_desc_ppd_2: 'Manipuler et configurer un robot industriel Kuka',
      job_desc_ppd_3: 'Réparer des systèmes électriques, mécaniques et hydrauliques',
      exp_node: 'Programmation back-end en javascript avec de multiples librairies comme Express.js.',
      exp_rails: 'Programmation back-end RESTful, gestion de base de données, framework MVC.',
      exp_react: 'Programmation de UI en javascript avec React.js ou en en simple javascript.',
      exp_css: 'Design front end avec CSS et HTML. Familiarité avec la librairie Bootstrap.',
      exp_cpp: 'Programmation de bas niveau en C/C++. Code pour microcontrôleur Arduino et conception de jeux vidéo.',
      exp_godot: "Programmation d'une simulation de bras robotique avec le logiciel Godot.",
      title_prog: 'EXPÉRIENCE EN PROGRAMMATION',
      title_exp: 'EXPÉRIENCE PROFESSIONNELLE',
      title_employers: 'ANCIENS EMPLOYEURS',
      contact_text: "Pour toutes questions ou commentaires, vous pouvez me rejoindre à l'adresse courriel suivante:",
      contact_title: "Entrer en contact",
      btn_copy: "Copier",
    }

    text = in_english? ? english[key.to_sym] : french[key.to_sym]
    raise 'Translation missing; Key: '+key.to_s+'; Locale: '+get_locale.to_s unless text
    text.html_safe
  end
end

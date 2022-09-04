OUT_DIR = "docs"

require 'set'
require 'nokogiri'
  
$dependencies = Set.new
    
LOCALES = ["fr", "en"]

def _fullpath(path)
  path.start_with?('http') ? path : "http://localhost:3001#{path.start_with?('/') ? path : '/'+path}"
end

def _relative_path(path)
  path.start_with?('http') ? path[21..-1] : path
end

# Make the link relative instead of absolute.
def convert_link(link, depth)
  $dependencies << link
  base = link.start_with?('/') ? link[1..-1] : link
  return depth == 0 ? base : '../'*depth+base
end
def convert_links
  puts "CONVERTING LINKS"
  Dir.glob("#{OUT_DIR}/**/*.html") do |path|
    rel = File.dirname(path)[(OUT_DIR.length+1)..-1]
    depth = (rel.nil? || rel == '') ? 0 : rel.count('/')+1
    html = File.read(path)
    doc = Nokogiri::HTML5(html)
    links = doc.css 'a'
    links.each do |link|
      link['href'] = convert_link(link['href'], depth)
    end
    links = doc.css 'link'
    links.each do |link|
      link['href'] = convert_link(link['href'], depth)
    end
    imgs = doc.css 'img'
    imgs.each do |img|
      img['src'] = convert_link(img['src'], depth)
    end
    videos = doc.css 'video'
    videos.each do |video|
      video['src'] = convert_link(video['src'], depth)
    end
    scripts = doc.css 'script'
    scripts.each do |script|
      script['src'] = convert_link(script['src'], depth)
    end
    File.write(path, doc.to_html)
  end
end

# The url will be without an extension. Instead of /blah.html, it's going to be /blah.
# In order to do this, create a folder and add an index.html file. => /blah/index.html
def download_short_url(path)
  puts "Downloading page w/ html ext: "+_fullpath(path)
  full = File.join(OUT_DIR, _relative_path(path))
  FileUtils.mkdir_p(full) unless File.directory?(full)
  system("wget #{_fullpath(path)} -q -O #{full}/index.html") # -q => quiet; -O => output file name; -k => relative file path
  return full
end

# Download the url with the extension. /blah.html
def download_with_ext(path)
  puts "Downloading item: "+_fullpath(path)
  full = File.join(OUT_DIR, _relative_path(path))
  dir = File.dirname(full)
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
  system("wget #{_fullpath(path)} -q -O #{full}") # -q => quiet; -O => output file name; -k => relative file path
end

def download_dependencies

  extensions = ['.jpg', '.jpeg', '.png', '.svg', '.mp4', '.zip', '.css', '.js']

  puts "DOWNLOADING DEPENDENCIES..."
  list = $dependencies
  list.each do |item|
    next unless extensions.include?(File.extname(item))
    download_with_ext(item)
  end
end

namespace :website do

  task clear: :environment do
    FileUtils.rm_rf(OUT_DIR)
  end

  task build: [:environment, :clear, :build_custom] do
  end

  task :url_helpers do
    include Rails.application.routes.url_helpers
  end

  task build_custom: [:environment, :url_helpers] do 
    download_short_url(root_path)
    download_with_ext('/fonts/IndieFlower-Regular.ttf') # Ugly patch. The issue is that the dependency is inside another dependency (the stylesheet), so it is not downloaded.
    LOCALES.each do |locale|
      download_short_url(home_path(locale: locale))
      download_short_url(robot_path(locale: locale))
      download_short_url(prog_path(locale: locale))
      download_short_url(conception_path(locale: locale))
      download_short_url(cupboard_path(locale: locale))
      download_short_url(chuck_laser_path(locale: locale))
      download_short_url(mattress_pump_path(locale: locale))
      download_short_url(projects_path(locale: locale))
      download_short_url(about_path(locale: locale))
      download_short_url(contact_path(locale: locale))
    end
    convert_links
    download_dependencies
  end

  task convert_links: [:environment] do
    convert_links
  end

end

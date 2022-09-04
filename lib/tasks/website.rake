OUT_DIR = "docs"

require 'set'
require 'nokogiri'
  
#$download_list ||= []
  
$dependencies = Set.new
    
#LOCALES = ["fr-CA"]
LOCALES = ["fr", "en"]

#def add_download(path)
#  puts "Adding path to download: #{path}"
#  $download_list << "http://localhost:3001#{path}"
#end

#def execute_download
#  puts "Executing the download for the download list"
#  File.open("tmp/download-list", 'w') { |file| file.write($download_list.join("\n")) }
#  # -e robots=off Download even if not allowed by robots.txt
#  # -P prefix Download inside tmp directory
#  # -p ?????
#  # -nv no verbose
#  system("wget -nv -e robots=off -p -k -P tmp -i tmp/download-list")
#  #system("wget -q -e robots=off -p -P tmp -i tmp/download-list")
#  move_files_without_extensions
#  $download_list.clear
#end

#def move_files_without_extensions
#
#  puts "Moving the files to directories and index.html"
#
#  Dir.glob("#{OUT_DIR}/**/*") do |path|
#    next if path.starts_with?("#{OUT_DIR}/images")
#    next if path == '.' or path == '..'
#    next unless File.extname(path).blank?
#    next if File.directory?(path)
#    tmp_dir_path = path+"-tmp"
#    Dir.mkdir(tmp_dir_path)
#    File.rename path, tmp_dir_path+"/index.html"
#    File.rename tmp_dir_path, path
#  end
#end

def _fullpath(path)
  path.start_with?('http') ? path : "http://localhost:3001#{path}"
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
    puts rel
    puts depth
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
  puts "DEPENDENCIES: #{$dependencies}"
end

def _download_index(path)
  puts _fullpath(path)
  full = "#{OUT_DIR}#{_relative_path(path)}"
  FileUtils.mkdir_p(full) unless File.directory?(full)
  system("wget #{_fullpath(path)} -q -O #{full}/index.html") # -q => quiet; -O => output file name; -k => relative file path
  return full
end

def _download(path)
  puts _fullpath(path)
  full = "#{OUT_DIR}#{_relative_path(path)}"
  dir = File.dirname(full)
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
  system("wget #{_fullpath(path)} -q -O #{full}") # -q => quiet; -O => output file name; -k => relative file path
end

def download(path)
  full = _download_index(path)
  # sudo apt-get install html-xml-utils
  #links = `hxwls #{full}/index.html`.split("\n")
end

def download_dependencies

  extensions = ['.jpg', '.jpeg', '.png', '.svg', '.mp4', '.zip', '.css', '.js']

  puts "DOWNLOADING DEPENDENCIES..."
  list = $dependencies
  puts list
  list.each do |item|
    next unless extensions.include?(File.extname(item))
    _download(item)
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
    download(root_path)
    download('/fonts/IndieFlower-Regular.ttf') # Ugly patch. The issue is that the dependency is inside another dependency (the stylesheet), so it is not downloaded.
    LOCALES.each do |locale|
      download(home_path(locale: locale))
      download(robot_path(locale: locale))
      download(prog_path(locale: locale))
      download(conception_path(locale: locale))
      download(cupboard_path(locale: locale))
      download(chuck_laser_path(locale: locale))
      download(mattress_pump_path(locale: locale))
      download(projects_path(locale: locale))
      download(about_path(locale: locale))
      download(contact_path(locale: locale))
      convert_links
      download_dependencies
    end
  end

  task convert_links: [:environment] do
    convert_links
  end

  #desc "TODO"
  #task build_main: [:environment, :url_helpers] do

  #  add_download("/cv")
  #  execute_download

  #  add_download(home_path)
  #  add_download(robot_path)
  #  add_download(prog_path)
  #  add_download(conception_path)
  #  add_download(cupboard_path)
  #  add_download(chuck_laser_path)
  #  add_download(mattress_pump_path)
  #  add_download(projects_path)
  #  execute_download
  #end

end

OUT_DIR = "tmp/localhost:3001"

require 'set'
  
$download_list ||= []
    
LOCALES = ["fr-CA"]
#LOCALES = ["fr", "en"]

def add_download(path)
  puts "Adding path to download: #{path}"
  $download_list << "http://localhost:3001#{path}"
end

def execute_download
  puts "Executing the download for the download list"
  File.open("tmp/download-list", 'w') { |file| file.write($download_list.join("\n")) }
  # -e robots=off Download even if not allowed by robots.txt
  # -P prefix Download inside tmp directory
  # -p ?????
  # -nv no verbose
  system("wget -nv -e robots=off -p -k -P tmp -i tmp/download-list")
  #system("wget -q -e robots=off -p -P tmp -i tmp/download-list")
  move_files_without_extensions
  $download_list.clear
end

def move_files_without_extensions

  puts "Moving the files to directories and index.html"

  Dir.glob("#{OUT_DIR}/**/*") do |path|
    next if path.starts_with?("#{OUT_DIR}/images")
    next if path == '.' or path == '..'
    next unless File.extname(path).blank?
    next if File.directory?(path)
    tmp_dir_path = path+"-tmp"
    Dir.mkdir(tmp_dir_path)
    File.rename path, tmp_dir_path+"/index.html"
    File.rename tmp_dir_path, path
  end
end

def _fullpath(path)
  path.start_with?('http') ? path : "http://localhost:3001#{path}"
end

def _relative_path(path)
  path.start_with?('http') ? path[21..-1] : path
end

def _download_index(path)
  puts _fullpath(path)
  full = "tmp/testing#{_relative_path(path)}"
  FileUtils.mkdir_p(full) unless File.directory?(full)
  system("wget #{_fullpath(path)} -k -q -O #{full}/index.html") # -q => quiet; -O => output file name; -k => relative file path
  return full
end

def _download(path)
  puts _fullpath(path)
  full = "tmp/testing#{_relative_path(path)}"
  system("wget #{_fullpath(path)} -k -q -O #{full}") # -q => quiet; -O => output file name; -k => relative file path
end

def download(path)
  $dependencies ||= Set.new
  $downloaded ||= Set.new

  full = _download_index(path)
  # sudo apt-get install html-xml-utils
  links = `hxwls #{full}/index.html`.split("\n")
  $dependencies.merge(links)
  $downloaded << path

end

def download_dependencies

  extensions = ['.jpg', '.jpeg', '.png', '.svg', '.mp4', '.zip']

  puts "DOWNLOADING DEPENDENCIES..."
  list = $dependencies - $downloaded
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
    download(home_path)
    download(robot_path)
    download(prog_path)
    download(conception_path)
    download(cupboard_path)
    download(chuck_laser_path)
    download(mattress_pump_path)
    download(projects_path)
    download_dependencies
  end

  desc "TODO"
  task build_main: [:environment, :url_helpers] do

    add_download("/cv")
    execute_download

    add_download(home_path)
    add_download(robot_path)
    add_download(prog_path)
    add_download(conception_path)
    add_download(cupboard_path)
    add_download(chuck_laser_path)
    add_download(mattress_pump_path)
    add_download(projects_path)
    execute_download
  end

end

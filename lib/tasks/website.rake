OUT_DIR = "tmp/localhost:3001"
  
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
  system("wget -nv -e robots=off -p -P tmp -i tmp/download-list")
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

namespace :website do

  task clear: :environment do
    FileUtils.rm_rf(OUT_DIR)
  end

  task build: [:environment, :clear, :build_main] do
  end

  task :url_helpers do
    include Rails.application.routes.url_helpers
  end

  desc "TODO"
  task build_main: [:environment, :url_helpers] do

    add_download("/")
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

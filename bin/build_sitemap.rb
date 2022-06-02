#!/usr/bin/env ruby

entries = []

#
#paths = ['qc/index.html', 'qc/recettes/']
#paths.each do |basepath|
#  if basepath[-1] == "/"
    #Dir["docs/#{basepath}**/*.*"].each do |path|
    Dir["docs/**/*.*"].each do |path|
      next if File.directory?(path)
      next if path.start_with? "docs/icons/"
      next if path.end_with? ".js"
      next if path.end_with? ".css"
      next if path.end_with? "sitemap.xml"
      entries << path
    end
#  else
#    entries << "docs/#{basepath}"
#  end
#end

require 'builder'

#now = Time.now.strftime("%Y-%m-%d")

xml = Builder::XmlMarkup.new( :indent => 2 )
xml.instruct! :xml, :encoding => "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do |p|
  entries.each do |entry|
    lastmod = `git log -1 --pretty="format:%cs" "#{entry}"`
    if lastmod.empty?
      puts "Warning: File #{entry} has not been commited yet."
    else
      p.url do |u|
        path = entry.end_with?("/index.html") ? entry[5..-11] : entry[5..-1]
        u.loc "http://www.hedacuisine.com/#{path}"
        u.lastmod lastmod
        #u.lastmod lastmod.empty? ? now : lastmod
      end
    end
  end
end

File.open("keep/sitemap.xml", 'w') { |file| file.write(xml.target!) }
system("cp keep/sitemap.xml docs/")

#puts xml.target!


# htmlからmdに変換する

require 'nokogiri'
require 'pp'
require 'fileutils'

year = [2003, 2004, 2005, 2006, 2009, 2011, 2013]

year.each do |y|
  Dir.glob("./#{y}/**/*.html") do |file|
    id = file.to_s.gsub(/\.\/(\d{4})\/([0-9]*)\/(.*)\.html$/, '\3')
    File.open(file, 'r') do |f|
      doc = Nokogiri::HTML f
      html = doc.css('.cassette .inner').map{|e|e.inner_html}
      date = doc.css('.headline.center.sentence').map{|e|e.inner_html.split('<br>').first.gsub('年', '-').gsub('月', '-').gsub('日', '').gsub(' ', '').split('-').map{|i| i.size == 1 ? "0#{i}" : i}.join('-')}.first
      title = doc.css('.headline.center.sentence').map{|e|e.inner_html.split('<br>').last}.first
      out = "hoge/#{date}-#{id}.html.md"
      FileUtils.touch(out)
      head = "---\ntitle: #{title}\ndate: #{date}\nid: #{id}\n---\n\n"
      File.open(out, 'a') do |o|
        o.puts head
        o.puts html
      end
    end
  end
end

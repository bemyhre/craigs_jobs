#!/usr/bin/env ruby
require 'mechanize'

class Job
  attr_accessor :loc, :area, :cat, :date, :text, :link
  def initialize(loc, area, cat, date, text, link)
    @loc = loc
    @area = area
    @cat = cat
    @date = date
    @text = text
    @link = link
  end
end

@jobs = []
@date

agent = Mechanize.new

#change this to the cities you want
locations = ['milwaukee', 'madison']
#change this to the categories you want
categories = ['sof', 'sad', 'tch', 'web']

locations.each do |location|
  categories.each do |category|
    page = agent.get("http://#{location}.craigslist.org/#{category}/")
    page.search('//h4[@class="ban"]|//p/a').each do |found|
      if found.name=="h4" && !found.text.empty?
        @date = Time.parse(found.text)
        @date = Time.parse("#{found.text} #{Time.now.year-1}") if @date > Time.now
      else
        @jobs << Job.new(location,
                         (found.next.next.nil? ? "" : found.next.next.text),
                         category,
                         @date,
                         found.text,
                         "<a  href='" + found.attributes["href"].value + "'>" + found.text[0,40] + "</a>"
                        )

      end
    end
  end
end


newFile = File.open("craigs_jobs.html", 'w')
newFile.syswrite "<html><body>
                  <table class='sortable' id='jobs'><thead>
                  <tr><th scope=col>Date</th>
                  <th scope=col>Title</th>
                  <th scope=col>Category</th>
                  <th scope=col>Location</th>
                  <th scope=col>Area</th>
                  </tr></thead><tbody>"

@jobs.each do |job|
  newFile.syswrite "<tr><td>#{job.date.strftime("%Y/%m/%d")}</td>
                   <td>#{job.link}</td>
                   <td>#{job.cat}</td>
                   <td>#{job.loc}</td>
                   <td>#{job.area}&nbsp;</td></tr>"
end

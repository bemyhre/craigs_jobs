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

@Jobs = []

agent = Mechanize.new
@date

#change this to the cities you want
locs = ['milwaukee', 'madison']
#change this to the categories you want
cats = ['sof', 'sad', 'tch', 'web']

locs.each do |loc|
  cats.each do |cat|
    page = agent.get("http://#{loc}.craigslist.org/#{cat}/")
    page.search('//h4[@class="ban"]|//p/a').each do |found|
      if found.name=="h4" && !found.text.empty?
        @date = Time.parse(found.text)
        if @date > Time.now
          @date = Time.parse(found.text + " 2010")
        end
      else
        @Jobs << Job.new(loc,
                         (found.next.next==nil ? "" : found.next.next.text),
                         cat,
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
                  <th scope=col>Cat</th>
                  <th scope=col>Loc</th>
                  <th scope=col>Area</th>
                  </tr></thead><tbody>"

@Jobs.each do |job|
  newFile.syswrite "<tr><td>#{job.date.strftime("%Y/%m/%d")}</td>
                   <td>#{job.link}</td>
                   <td>#{job.cat}</td>
                   <td>#{job.loc}</td>
                   <td>#{job.area}&nbsp;</td></tr>"
end

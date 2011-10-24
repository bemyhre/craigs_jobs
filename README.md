# Craigslist Job Scraper

My first Ruby script.  Written when I was perusing craigslist daily for jobs, and wanted several categories and cities on one page.

Currently, it takes posts from the categories of software, systems, tech support, and web design.

##Usage
Run the script with:

    ruby cl.rb

and it'll generate an html file in the same directory called **craigs_jobs.html**.

Default locations are Madison and Milwaukee, WI, but you can pass locations as additional arguments, e.g.

    ruby cl.rb madison sfbay

will give you job listings from Madison and San Francisco.

##Dependencies

mechanize

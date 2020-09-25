require 'open-uri'
require "nokogiri"
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_index = doc.css(".student-card a")
    student_index.collect do |element|
      {
        :name => element.css(".student-name").text, 
        :location => element.css(".student-location").text, 
        :profile_url => element.attr('href')
      }
  end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    returned_hash = {}
    social_media = doc.css(".vitals-container .social-icon-container a")
    # not all students have all social media
    # iterate and assing if icon exists
    social_media.each do |icon|
      if icon.attr('href').include?("twitter")
        returned_hash[:twitter] = icon.attr('href')
        elsif icon.attr('href').include?("linkedin")
        returned_hash[:linkedin] = icon.attr('href')
        elsif icon.attr('href').include?("github")
        returned_hash[:github] = icon.attr('href')
      else
        returned_hash[:blog] = icon.attr('href')
      end
    end
    returned_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    returned_hash[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text
    returned_hash
  end
 
end


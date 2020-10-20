require "open-uri"
require "nokogiri"

Episode.destroy_all

url = "https://www.accenture.com/de-de/careers/local/accenture-meets-esports?src=SOMS&c=car_glb_meetourpeople_11308187&n=smc_0920&abc=curated+daily+content_linkedin_100001570262257&linkId=100000016821004"

html_doc = Nokogiri::HTML(open(url).read)

puts "Scraping Accenture webpage..."

html_doc.search('#block-section-profiles .modal-play').each do |element|
  a = Episode.new

  a.url = element.attribute('data-video-src').value
  title = element.attribute('data-title').value
  if title.match(/(.+)<.+>(.+)<\/a>(.+)<.+>(.+)<\/a>(.+)/)
    a.title = title.match(/(.+)<.+>(.+)<\/a>(.+)<.+>(.+)<\/a>(.+)/)[1..5].join
  else
    a.title = title.match(/(.+)<.+>(.+)<\/a>(.+)/)[1..3].join
  end
  a.save!
end

puts "#{Episode.count} episodes were created!"

require 'open-uri'
require 'net/http'
require 'json'
require 'nokogiri'
require 'time'


$data_url = "https://www.nasa.gov/api/2/ubernode/479003"
# uri = URI.parse(url)

# response = Net::HTTP.get_response(uri)
# html = response.body

# converting pdf data to obj 
def convert_data_to_obj(data_url)
    convet_to_uri = URI.parse(data_url)
    response = Net::HTTP.get_response(convet_to_uri)
    return JSON.parse(response.body)
  end

# creating the hash response

def create_hash()
    response_obj = convert_data_to_obj($data_url)
    data_hash = Hash.new
    data_hash["title"] = response_obj['_source']['title']
    date = Time.parse(response_obj['_source']['promo-date-time'])
    data_hash["date"] = date.strftime("%B %d %Y")
    data_hash["release_no"] = response_obj['_source']['release-id']
    body = Nokogiri::HTML(response_obj['_source']['body'])
    data_hash["body"] = body.css("p").text
    return data_hash
end

print create_hash


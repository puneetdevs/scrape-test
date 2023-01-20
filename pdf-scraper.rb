require 'pdf/reader/html'
require 'json'
require 'nokogiri'

$pdf_path = '/var/www/html/scraper/S18009_2021-05-03_N1.pdf'

# converting pdf data into html 
def convert_pdf_to_html(pdf_path)
  pdf = PDF::Reader.new(pdf_path)
  pdfToHtml = pdf.to_html
  return Nokogiri::HTML(pdfToHtml)
end

# creating the hash response

def create_hash()
  html_response = convert_pdf_to_html($pdf_path)
  data_hash = Hash.new
  data_hash["petitioner"] = html_response.xpath('//p[contains(text(), "Supreme Court No")]').text.split("Supreme Court No")[0]
  data_hash["state"] = html_response.xpath('//p[contains(text(), "In the Supreme Court of the")]').text.split("n the Supreme Court of the")[-1]
  data_hash["amount"] = html_response.xpath('//p[contains(text(), "$")]').text.split.select { |str| str.start_with?("$")}[0]
  data_hash["date"] = html_response.xpath('//p[contains(text(), "Date of Notice")]').text.split("Date of Notice")[1]
  return data_hash
end

print create_hash

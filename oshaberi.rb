require 'bundler'
Bundler.require
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000 })
end

today = Date.today.strftime("%Y%m%d")
session = Capybara::Session.new(:poltergeist)

session.driver.headers = {
  'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
}
session.visit "http://www.asahi.co.jp//oshaberi/recipe/#{today}.html"

# HTMLを取得
html = session.html
# htmlをパースしてオブジェクト生成
doc = Nokogiri::HTML.parse(html)

# 料理名を取得
name_elements = doc.css('.recipe_title2')
# 作り方を取得
recipi_elements = doc.css('table[width="460"] td[width="430"]')
# 材料を取得
ingredients_elements = doc.css('table[width="440"] tr')
#brを改行コードに変換
recipi_elements.search('br').each do |br|
  br.replace("\n")
end
ingredients_elements.search('br').each do |tr|
  tr.replace("\n")
end

puts '料理名 : ' + name_elements.text
puts "-----------------------------------------------\n"
puts "作り方： \n" + recipi_elements.text
puts "-----------------------------------------------\n"
puts "材料： \n" + ingredients_elements.text

FactoryBot.define do
  factory :address do
    gimei = Gimei.name
    address = Gimei.address
    name { gimei.kanji }
    name_kana { gimei.katakana }
    gender { gimei.gender == :male ? "男" : "女" }
    phone { ["03-1111-1111", "090-1111-1111", "012-3456-7890", "0123-456-7890"].sample }
    mail { Faker::Internet.email }
    zipcode { "123-4567" }
    address1 { address.prefecture.kanji }
    address2 { address.city.kanji }
    address3 { address.town.kanji }
    address4 { "#{(0...9).to_a.sample}-#{(0...9).to_a.sample}" }
    age { (0...100).to_a.sample }
  end
end
FactoryBot.define do
  factory :order do
    name { 'サンプルマン' }
    email { 'test@example.com' }
    telephone { '0312345678' }
    delivery_address { '東京都葛飾区亀有公園前' }
    other_comment { 'その他ご要望' }
    payment_method_id { 1 }
    direct_mail_enabled { true }
  end
end
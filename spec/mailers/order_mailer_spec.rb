require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  let(:order_id) { 123 }
  let(:expected_text_body) do
    <<~"MAILBODY"
    サンプルマン様

    この度はご注文いただき、誠にありがとうございます。
    
    以下の注文内容に基づき、商品の発送をさせていただきます。
    到着まで今しばらくお待ちください。
    
    [注文内容]
    商品:おいしいバナナ(100円/個)
    数量:3
    商品:たのしいオレンジ(200円/個)
    数量:2
    合計金額:770円(税込)
    
    支払い方法:クレジットカード
    お届け先住所:東京都葛飾区亀有公園前
    電話番号:0312345678
    その他・ご要望:その他ご要望
    メールマガジンの配信:配信を希望する
    
    -------------------------------------
    楽しい果物ファーム
    https://fruit.example.com
    メール: support@example.com
    -------------------------------------
    MAILBODY
  end
  let(:expected_html_body) do
    <<~"MAILBODY"
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style>
          /* Email styles need to be inline */
        </style>
      </head>

      <body>
      サンプルマン様<br>
      <br>
      この度はご注文いただき、誠にありがとうございます。<br>
      <br>
      以下の注文内容に基づき、商品の発送をさせていただきます。<br>
      到着まで今しばらくお待ちください。<br>
      
      [注文内容]<br>
      商品:おいしいバナナ(100円/個)<br>
      数量:3<br>
      商品:たのしいオレンジ(200円/個)<br>
      数量:2<br>
      合計金額:770円(税込)<br>
      
      支払い方法:クレジットカード<br>
      お届け先住所:東京都葛飾区亀有公園前<br>
      電話番号:0312345678<br>
      その他・ご要望:その他ご要望<br>
      メールマガジンの配信:配信を希望する<br>
      <br>
      -------------------------------------<br>
      楽しい果物ファーム<br>
      <a href="https://fruit.example.com"></a><br>
      メール:<a href="support@example.com">support@example.com</a><br>
      -------------------------------------<br>
      </body>
    </html>
    MAILBODY
  end

  describe '#mail_to_user' do
    let(:deliverd_mail) { OrderMailer.mail_to_user(order_id).deliver }
    let(:expected_to) { ['test@example.com'] }

    before do
      create(:order, id: order_id,
                     order_products_attributes: [
                      attributes_for(:order_product, product_id: 1, quantity: 3),
                      attributes_for(:order_product, product_id: 2, quantity: 2),
                     ])
    end

    it '正しいフォーマットでメールが作成される' do
      expect(deliverd_mail.to).to eq expected_to
      expect(deliverd_mail[:from].formatted).to eq ['support@example.com']
      expect(deliverd_mail.cc).to eq nil
      expect(deliverd_mail.bcc).to eq nil
      expect(deliverd_mail.subject).to eq 'ご注文ありがとうございます'
      expect(deliverd_mail.text_part.body.to_s).to eq expected_text_body.gsub(/\n/, "\r\n")
    end
  end
end
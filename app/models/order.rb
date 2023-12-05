require 'nkf'

class Order < ApplicationRecord
  belongs_to :payment_method
  
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, length: { maximum: 100 }, email_format: true
  validates :telephone, presence: true, length: { maximum: 11 }, numericality: { only_integer: true }
  validates :delivery_address, presence: true, length: { maximum: 100 }
  validates :payment_method_id, presence: true
  validates :other_comment, length: { maximum: 1_000 }
  validates :direct_mail_enabled, inclusion: { in: [true, false], message: 'について選択してください'}

  after_initialize :format_telephone
  after_initialize :format_email

  private

  # 電話番号を全角から半角に変換
  def format_telephone
    return if telephone.blank?
    self.telephone = telephone.tr('０-９', '0-9').delete('^0-9')
  end

  # メールアドレスの変換
  def format_email
    return if email.blank?
    self.email = NKF.nkf('-w -Z4', email)
  end
end
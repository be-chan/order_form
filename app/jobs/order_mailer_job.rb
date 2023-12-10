class OrderMailerJob < ApplicationJob
  queue_as :default

  # 非同期処理するためのメソッド名はperformにすると言うが決まっているみたい
  def perform(order_id)
    OrderMailer.mail_to_user(order_id).deliver
  end
end
class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { in: 1..20 }

  delegate :name, to: :product # order_product.product.name -> order_product.name 右側の書き方が実現出来るので、冗長でなくなる。
end


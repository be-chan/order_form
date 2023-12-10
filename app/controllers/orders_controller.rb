class OrdersController < ApplicationController
  def new
    @order = Order.new
    @order.order_products.build
  end

  def confirm
    @order = Order.new(order_params)

    # 注文内容の追加ボタンを増やすための記述
    if params.key?(:add_product)
      @order.order_products << OrderProduct.new
      return render :new
    end

    # 注文内容の追加ボタンを減らすための記述
    if params.key?(:delete_product)
      filter_order_products
      return render :new
    end

    return render :new if @order.invalid?
  end

  def create
    @order = Order.new(order_params)
    return render :new if params[:button] == 'back'

    if @order.save
      session[:order_id] = @order.id
      return redirect_to complete_orders_path
    end

    render :confirm
  end

  def complete
    @order = Order.find_by(id: session[:order_id])
    return redirect_to new_order_path if @order.blank?

    session[:order_id] = nil
  end

  private

  def order_params
    params
    .require(:order)
    .permit(
      :name,
      :email,
      :telephone,
      :delivery_address,
      :payment_method_id,
      :other_comment,
      :direct_mail_enabled,
      inflow_source_ids: [],
      order_products_attributes: %i[product_id quantity]
    )
  end

  # 元の@order.order_productsのオブジェクトをrejectとwith_indexでindexと削除ボタンのparamsでindexが一致したものを除外して、上書き代入すると言う手法
  def filter_order_products
    @order.order_products = @order.order_products
                                  .reject
                                  .with_index { |_, index| index == params[:delete_product].to_i}
  end
end
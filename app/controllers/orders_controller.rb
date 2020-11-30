class OrdersController < ApplicationController
  include CurrentCart

  skip_before_action :authorize, only: [:new, :create]

  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new

    prepare_order_variables
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        ChargeOrderJob.perform_later(@order, pay_type_params.to_h)
        format.html { redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks') }
        format.json { render :show, status: :created, location: @order }
      else
        prepare_order_variables
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pay_type_params
    if order_params[:pay_type] == 'Credit card'
      params.require(:order).permit(:credit_card_number, :expiration_date)
    elsif order_params[:pay_type] == 'Check'
      params.require(:order).permit(:routing_number, :account_number)
    elsif order_params[:pay_type] == 'Purchase order'
      params.require(:order).permit(:po_number)
    else
      {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end

    def ensure_cart_isnt_empty
      if @cart.line_items.empty?
        redirect_to store_index_url, notice: 'Your cart is empty'
      end
    end

    def prepare_order_variables
      @secure_string = SecureRandom.uuid
      @time_now = Time.now.to_i
      @app_id = 'ms_7dbIUpCXyfH' # TODO: take from yml, add yml to gitignore
      @kind = 'sale'
      @currency = 'PLN'
      @title = 'Zamówienie testowe MC'

      @cart = Cart.find(session[:cart_id])
      @cart_price = @cart.total_price.to_d
      @cart_price = sprintf('%.2f', @cart_price)

      @checksum = Digest::MD5.hexdigest(@app_id + '|' + @kind + '|' + @secure_string.to_s + '|' + @cart_price.to_s + '|' + @currency + '|' + @time_now.to_s + '|' + 'UemypI5GUsEz')
    end
end

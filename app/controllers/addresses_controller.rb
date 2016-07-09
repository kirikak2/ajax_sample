class AddressesController < ApplicationController
  protect_from_forgery except: [:update, :destroy, :create]
  before_action :set_address, only: [:update, :destroy]

  # GET /addresses.json
  def index
    @addresses = Address.all

    case params[:mode]
    when "and"
      condition = "and"
    when "or"
      condition = "or"
    else
      condition = "and"
    end

    conditions = nil
    conditions = join_condition(conditions, :name, :string, condition)
    conditions = join_condition(conditions, :name_kana, :string, condition)
    conditions = join_condition(conditions, :email, :string, condition)
    conditions = join_condition(conditions, :address1, :string, condition)
    conditions = join_condition(conditions, :age, :integer, condition)

    if conditions.present?
      @addresses = @addresses.where(conditions)
    end
    @total_count = @addresses.count('*')

    if params[:columns].present?
      @columns = [:id] + params[:columns].split(',')
      @columns.reject!{|name| Address.column_names.exclude?("#{name}") }
      @addresses = @addresses.select(@columns)
    end


    if params[:per].present?
      @addresses = @addresses.limit(params[:per])
      if params[:page].present?
        @addresses = @addresses.offset(params[:per].to_i * (params[:page].to_i - 1))
      end
    end
  rescue => e
    render json: e.message, status: :unprocessable_entity
  end

  # POST /addresses.json
  def create
    @address = Address.new(address_params)

    respond_to do |format|
      if @address.save
        format.json { render :show, status: :created, location: @address }
      else
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  rescue ArgumentError => e
    render json: e.message, status: :unprocessable_entity
  end

  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.json { render :show, status: :ok, location: @address }
      else
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  rescue ArgumentError => e
    render json: e.message, status: :unprocessable_entity
  end

  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  rescue ArgumentError => e
    render json: e.message, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      permit_params = [:name, :name_kana, :gender, :phone, :mail, :zipcode,
        :address1, :address2, :address3, :address4, :address5, :age]

      params.fetch(:address, [ :data ])
      if params[:data].present?
        data = JSON.parse(params[:data])
        data.each_key do |key|
          raise ArgumentError, "Bad parameter" if permit_params.exclude?(key.to_sym)
        end
      else
        raise ArgumentError, "No Data"
      end
      data
    end

    def join_condition(conditions, name, column_type, and_or_or)
      if params[name].present?
        value = params[name]
        if conditions.nil?
          case column_type
          when :string
            conditions = Address.arel_table[name].matches("%#{value}%")
          when :integer
            conditions = Address.arel_table[name].eq(value)
          end
        else
          case column_type
          when :string
            conditions = conditions.__send__(and_or_or, Address.arel_table[name].matches("%#{value}%"))
          when :integer
            conditions = conditions.__send__(and_or_or, Address.arel_table[name].eq(value))
          end
        end
      end
      conditions
    end
end

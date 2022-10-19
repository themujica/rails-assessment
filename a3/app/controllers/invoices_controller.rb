class InvoicesController < ApplicationController
  require 'rake'


  before_action :authenticate_user!, only: [:edit, :destroy, :update, :create, :show, :delete]

  skip_before_action :verify_authenticity_token, :only => [:insert,:inquire_enterprise]

  @root_url = "/invoices/index"

  layout 'application'

  # Listar todos los registros de la Base de Datos 
  def index
    @Invoices = Invoice.order("id DESC")
    if params[:concept].present? && params[:type_search].present?
      @Invoices = @Invoices.where("#{params[:type_search]} ILIKE ?", "%#{params[:concept]}%")
    elsif params[:date].present?
      @Invoices = @Invoices.where("date = ?", params[:category_id])
    else
      @Invoices = Invoice.all()
    end

  end

  # Leer los detalles de un registro 
  def show
    @Invoices = params[:id]
    @Invoices = Invoice.where(id: @Invoices)
  end


  def create
    @Invoices = Invoice.new
  end

  # Procesamos la creación de un registro en la base de datos
  def insert
       @Invoices = Invoice.new(invoice_params)
       if @Invoices.save
        @ini = "/invoices/index"
        flash[:notice] = "Factura creado correctamente !"
        redirect_to @ini

      else
        render :edit, status: :unprocessable_entity
      end
  end

  def update
    # Pasamos el 'id' del registro a actualizar (método index)   
    @Invoices = Invoice.find(params[:id])
    @Invoices = Invoice.where(id: @Invoices)

  end
  def execute_rake

    Rake::Task[params['XMLinvoices_files:leerXML']].invoke
    @ini = "/invoices/index"
    flash[:notice] = "Factura creado correctamente !"
    redirect_to @ini
  end

  # Procesamos la actualización de un registro en la base de datos 
  def edit

    # Pasamos el 'id' del registro a actualizar (método editar)    
    @Invoices = Invoice.find(params[:id])

    # Actualizamos el Archivo al servidor
    uploaded_file = params[:img]

    # Actualizamos un determinado registro en la base de datos
    if @Invoices.update(invoice_params)

      # Actualizamos la columna 'img' de la base de datos

    else
      render :edit
    end

    # Redireccionamos a la vista principal con mensaje 
    @ini = "/invoices/index"
    flash[:notice] = "Actualizado Correctamente !"
    redirect_to @ini

  end

  # Procesamos la eliminación de un registro de la base de datos
  def delete

    # Eliminamos un determinado registro en la base de datos, pasamos el 'id' del registro a eliminar
    @Invoices = Invoice.find(params[:id])

    Invoice.where(id: @Invoices).destroy_all

    # Redireccionamos a la vista principal con mensaje 
    @ini = "/invoices/index"
    flash[:notice] = "Eliminado Correctamente !"
    redirect_to @ini

  end
  def generate_qr(text)
    require 'barby'
    require 'barby/barcode'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'
    barcode = Barby::QrCode.new(text, level: :q, size: 5)
    base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
    "data:image/png;base64,#{base64_output}"
    Rails.logger.debug{">>> Base -->: #{base64_output} "}
    return base64_output
  end
  helper_method :generate_qr
  # Parámetros o campos que insertamos o actualizamos en la base de datos 

  private

  def invoice_params
    params.require(:invoice).permit( :invoice_uuid, :emitter_name, :emitter_rfc, :receiver_rfc, :receiver_name, :status, :amount, :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp)
  end
end

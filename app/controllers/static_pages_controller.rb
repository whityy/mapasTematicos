class StaticPagesController < ApplicationController
  def import
    StaticPage.import(params[:file])
    redirect_to root_url, notice: 'Datos mapa importados.'
  end

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def maps
    if params[:file]
			@tipo = params[:tipo]
			@localizacion = params[:localizacion]
			@titulo = params[:titulo]
			@grafico = params[:grafico]

			@file = params[:file].tempfile
			case File.extname(@file)
			when '.csv' then @data = Roo::CSV.new(params[:file].tempfile)
			when '.xls' then @data = Roo::Excel.new(params[:file].tempfile)
			when '.xlsx' then @data = Roo::Excelx.new(params[:file].tempfile)
			else @data = "Archivo no valido"
	  	end
    end
  end

  def configuracionMapa
  end

  def configuracionEstadistica
  end

end

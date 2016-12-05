require "prawn"
require "open-uri"
require 'stringio'
require "i18n"

class MapsController < ApplicationController
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!


	def index
		#homepage
	end

  def list
  	user_id = current_user.id ||= params[:user_id]
  	@maps = Map.where(user_id: user_id)
  end

  def show
  	if params[:id]
			map = Map.find(params[:id])
			@tipo = map.tipo
			@localizacion = map.localizacion
			@titulo = map.titulo
			@grafico = map.grafico
			@data = JSON.parse(map.data)
  	else
  		if params[:file]
				@tipo = params[:tipo]
				@localizacion = params[:localizacion]
				@titulo = params[:titulo]
				@grafico = params[:grafico]

				@file = params[:file].tempfile

				case File.extname(@file)
				when '.csv' then
					data = Roo::CSV.new(@file)
					data.each do |data|
						data = data[0].force_encoding('UTF-8')
					end
					@data = data
				when '.xls' then
					data = Roo::Excel.new(@file)
					data.each do |data|
						data = data[0].force_encoding('UTF-8')
					end
					@data = data
				when '.xlsx' then
					data = Roo::Excelx.new(@file)
					data.each do |data|
						data = data[0].force_encoding('UTF-8')
					end
					@data = data
				else
					#@data = null
		  	end
    	end
  	end
  end

  def save
		tipo = params[:tipo]
		localizacion = params[:localizacion]
		titulo = params[:titulo]
		grafico = params[:grafico]
		data = params[:data]

		@map = Map.new
		@map.tipo = tipo
		@map.titulo = titulo
		@map.localizacion = localizacion
		@map.grafico = grafico
		@map.data = data
		@map.user_id = current_user.id

		respond_to do |format|
      if @map.save
        format.html { redirect_to action: "list", user_id: @map.user_id }
      end
    end

  end

  def report
  	respond_to do |format|
			format.pdf do
				pdf = Prawn::Document.new
				charts64 = params[:charts64]
				charts_url = []
				charts64.each do |chart|
					image_cloud = Cloudinary::Uploader.upload(chart)
					charts_url.push(image_cloud["url"])
				end

				mapa = "http://maps.googleapis.com/maps/api/staticmap?center=#{params[:localizacion]}&zoom=5&scale=false&size=600x300&maptype=#{params[:tipomapa]}&format=png&visual_refresh=true"
				ciudades = params[:ciudades]
				ciudades.each_with_index do |ciudad, index|
					mapa = mapa + "&markers=icon:#{charts_url[index]}%7Cshadow:true%7C" + ciudad
				end
				pdf.image open(I18n.transliterate(mapa)), width: 540
				chartsHD = params[:chartsHD]
				chartsHD_url = []
				chartsHD.each do |chart|
    			pdf.image StringIO.new(Base64.decode64(splitBase64(chart)[:data])), width: 540
				end

				send_data pdf.render
			end
		end
  end

  def delete
   	@maps = Map.find(params[:id])
    @maps.destroy
    redirect_to action: "list"
  end

  def splitBase64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        extension: $1.split('/')[1] # "png"
        }
    end
  end

end

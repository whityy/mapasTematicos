class Map
	include Mongoid::Document
	field :tipo,              type: String
	field :localizacion, 	  type: String
	field :titulo,            type: String
	field :grafico,           type: String
	field :data,			  type: String
	field :user_id,           type: String
end

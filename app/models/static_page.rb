class StaticPage
  include Mongoid::Document
  field :nombre, type: String
  field :datos, type: Integer

  # def self.import(file)
  # 	CSV.foreach(file.path, headers: true) do |row|
  # 		staticpage = find_by_id(row["id"]) || new
  # 		 staticpage.attributes = row.to_hash.slice(*accessible_attributes)
  # 		 staticpage.save!
  # 	end
  # end

  # def self.import(file)
  # 	spreadsheet = Roo::Spreadsheet.open(file.path)
  # 	header = spreadsheet.row(1)
  # 	(2..spreadsheet.last_row).each do |i|
  #   	row = Hash[[header, spreadsheet.row(i)].transpose]
  #   	staticpage = find_by(id: row["id"]) || new
  #   	staticpage.attributes = row.to_hash
  #   	staticpage.save!
  # 	end
  # end

  def self.open_spreadsheet(file)
  	case File.extname(file.original_filename)
  	when '.csv' then Csv.new(file.path, nil, :ignore)
  	when '.xls' then Excel.new(file.path, nil, :ignore)
  	when '.xlsx' then Excelx.new(file.path, nil, :ignore)
  	else raise "Unknown file type: #{file.original_filename}"
  	end
  end
end

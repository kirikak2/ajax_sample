json.ignore_nil!
json.total @total_count
json.per params[:per].present? ? params[:per].to_i : @total_count
json.page params[:page].present? ? params[:page].to_i : 1
json.results @addresses do |address|
  if @columns.nil?
    json.extract! address, :id, :name, :name_kana, :gender, :phone, :mail, :zipcode, :address1, :address2, :address3, :address4, :address5, :age
  else
    json.extract! address, *@columns
  end
end

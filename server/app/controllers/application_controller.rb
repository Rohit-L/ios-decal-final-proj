class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def create_item
  	if User.all.empty?
  		User.create(name: "Rohit Lalchandani", uid: "1")
  	end

  	item = Item.create!(
  		picture: "https://cdn.pixabay.com/photo/2013/10/02/15/51/tree-189852_1280.jpg",
  		title: "Landscape",
  		description: "This is a picture of a landscape.",
  		viewNum: 34,
  		price: "20",
  		user: User.first
  	)

  	head :ok, content_type: "text/html"
  end

  def read_item
  	render json: Item.all.to_json(include: [:user])
  end

  def update_item
  	head :ok, content_type: "text/html"
  end

  def delete_item
  	head :ok, content_type: "text/html"
  end
end

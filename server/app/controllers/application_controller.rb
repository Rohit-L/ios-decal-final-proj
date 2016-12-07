require 'cloudinary'
require 'cloudinary/uploader'
require 'cloudinary/utils'

class ApplicationController < ActionController::Base

  # /item/read
  def read_item
  	render json: Item.all.to_json(include: [:user])
  end

  # /item/update
  def update_item
    puts params
    item = Item.find(params["item_id"])
    item.title = params["title"]
    item.description = params["description"]
    item.price = params["price"]
    item.save!
  	head :ok, content_type: "text/html"
  end

  # ?
  def delete_item
  	head :ok, content_type: "text/html"
  end

  # /user/create
  def create_user
    if !User.exists?(uid: params['id'])
      User.create(name: params['name'], uid: params["id"], email: params['email'])
    end
    head :ok, content_type: "text/html"
  end

  def create_item

    puts params
    upload = Cloudinary::Uploader.upload(params["file"].path, :format => 'png')

    user = User.where(uid: params["user_uid"]).first

    main_url = upload["url"].slice(0, upload["url"].index("upload") + 7)
    end_url = upload["url"].slice(upload["url"].index("upload") + 7, upload["url"].length)
    filename = end_url.slice(end_url.index("/"), end_url.length)
    final_url = main_url + "w_600" + filename
    puts final_url
    item = Item.create!(
      picture: final_url,
      title: params["title"],
      description: params["description"],
      viewNum: 0,
      price: params["price"],
      user: user,
      user_uid: user.uid
    )

    render json: item.to_json(include: [:user])
  end

end

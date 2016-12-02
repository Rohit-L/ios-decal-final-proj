class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def create_item
  	require "pry"; bindings.pry
  end

  def read_item
  end

  def update_item
  end

  def delete_item
  end
end

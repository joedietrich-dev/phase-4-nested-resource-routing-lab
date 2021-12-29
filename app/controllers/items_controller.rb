class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_invalid_user_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items, except: [:created_at, :updated_at]
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find(params[:id])
    render json: item, except: [:created_at, :updated_at]
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
      render json: item, except: [:created_at, :updated_at], status: :created
    end
  end

  private
  def item_params
    params.permit(:name, :description, :price)
  end

  def render_invalid_user_response
    render json: {error: "Record not found"}, status: :not_found
  end

end

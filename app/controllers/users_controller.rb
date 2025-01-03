class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: { message: user.errors }, status: 400
    end
  end

  private
  def user_params
    params.require(:user).permit(:clerk_id, :image_url)
  end
end

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # @user = User.find_by(id: params[:id])
    # @user = User.find_by_id(params[:id])
  end

  def new
  end

end

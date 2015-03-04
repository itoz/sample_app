class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        # @user = User.find_by(id: params[:id])
        # @user = User.find_by_id(params[:id])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save

            #保存の成功

            #サインイン
            sign_in @user

            flash[:success] = "Welcome to the Sample App!"
            redirect_to @user
        else
            render 'new'
        end
    end

    private

    #Strong Parameter
    def user_params
        params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
end

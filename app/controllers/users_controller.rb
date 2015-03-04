class UsersController < ApplicationController


    #EditとUpdate時は、ユーザーにサインインを要求するために
    #signed_in_userメソッドを定義してbefore_action :signed_in_userという形式で呼び出します
    before_action :signed_in_user, only: [:edit, :update]

    def show
        @user = User.find(params[:id])
        # @user = User.find_by(id: params[:id])
        # @user = User.find_by_id(params[:id])
    end

    def new
        @user = User.new
    end


    def edit
        @user = User.find(params[:id])
    end


    def update
        @user = User.find(params[:id])
        #attributesをチェックすることにより、更新にはパスワードが必ず要求されるようになる
        if @user.update_attributes(user_params)
            #更新に成功した場合
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            render "edit"
        end
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

        #Edit,Update時のサインインしていない場合のリダイレクト
        def signed_in_user
            # unless signed_in?
            #     flash[:notice] = "Please sign in."
            #     redirect_to signin_url
            # end
            #上記を簡素化
            redirect_to signin_url ,notice: "Please sign in." unless signed_in?
        end
end

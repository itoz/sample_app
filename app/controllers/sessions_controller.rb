class SessionsController < ApplicationController

    def new


    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)

        #Emailが一致するものが見つかった（ユーザーがいた）

        if user && user.authenticate(params[:session][:password])

            #ユーザーをサインインさせ　ユーザーページにリダイレクト
            sign_in user
            redirect_to user

        else

            #エラーメッセージを出し、サインインフォームを再描画
            flash.now[:error] = "Invalid email / password combination"
            render "new"

        end
    end

    def destroy
        sign_out
        redirect_to root_url
    end



end

class SessionsController < ApplicationController

    def new


    end


    # sign_in_pathにアクセス

    def create
        user = User.find_by(email: params[:session][:email].downcase)

        # Emailが一致するものが見つかった（ユーザーがいた）

        if user && user.authenticate(params[:session][:password])

            #ユーザーをサインインさせ、
            sign_in user

            #ユーザーページにリダイレクト
            #　redirect_back_orはsession_helperに定義した、
            #　フレンドリーフォワーディングの場合にはそのURLに飛ばすためのメソッド
            redirect_back_or user

        else

            #エラーメッセージを出し、サインインフォームを再描画
            flash.now[:error] = "Invalid email / password combination"
            render "new"

        end
    end

    #sign_out_path にアクセスがあった

    def destroy
        sign_out
        redirect_to root_url
    end



end

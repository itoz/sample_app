module SessionsHelper

    #------------------------
    # サインイン
    #------------------------

    def sign_in(user)

        #トークン新規生成(Userに定義したクラスメソッド)
        remember_token = User.new_remember_token
        #クッキーに保存（Railsのcookiesユーティリティ）
        cookies.permanent[:remember_token] = remember_token
        #トークンを暗号化してデータベースに保存
        user.update_attribute(:remember_token , User.encrypt(remember_token))

        #要素代入関数
        self.current_user = user

    end

    def signed_in?
        !current_user.nil?
    end

    #------------------------
    # サインアウト
    #------------------------
    def sign_out
        self.current_user = nil
        cookies.delete(:remember_token)
    end

    #要素代入関数
    # viewからもControllerからも呼び出せるcurrent_user
    def current_user=(user)
        @current_user = user
    end

    #remember_tokenを使用して現在のユーザーを検索、設定する。
    def current_user
        remember_token = User.encrypt(cookies[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
    end

    def current_user?(user)
        user == current_user
    end


    #------------------------
    # フレンドリーフォワーディング
    #------------------------

    def redirect_back_or(default)

        #保存されたセッションURLがあればそっちに飛ぶ
        redirect_to(session[:redirect_to] || default)
        #Railsが提供するsession機能。ブラウザを閉じたときに自動的に破棄されるcookies変数のインスタンスと同様のものととらえてよい。
        session.delete(:redirect_to)
    end

    def store_location
        session[:redirect_to] = request.url
    end


end


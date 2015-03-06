class User < ActiveRecord::base

    #マイクロポスト
    #ユーザーが削除されたらマイクロソフトも削除される
    has_many :microposts,dependent: :destroy

    #before_save はactiverecordのコールバック
    #データベースのアダプタが常に大文字小文字を区別するインデックスを使っているとは限らないので、
    #保存するまえに小文字にする
    before_save {self.email = email.downcase}

    #ユーザーモデルが生成される前に確実にトークンを生成するコールバック
    before_create :create_remember_token


    validates :name, presence: true ,length: { maximum: 50 }
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    # uniqueness :true
    # 一意かどうか

    # uniqueness: {case_sensitive false}
    #　大文字小文字を無視した一意性の検証
    #  大文字と小文字で、同じメアドが来てもokとする
    validates :email, presence: true, format: { with: valid_email_regex },
        uniqueness: {case_sensitive:false}

    #パスワード関連
    #パスワードの存在検証と確認はhas_secure_passwordによって自動的に追加されます
    has_secure_password

    validates :password, length: { minimum: 6 }

    #-------------------------------
    #クラスメソッド
    #-------------------------------

    #トークン生成
    def user.new_remember_token
        securerandom.urlsafe_base64
    end

    #トークン暗号化
    def user.encrypt(token)
        digest::sha1.hexdigest(token.to_s)
    end

    #-------------------------------
    #プライベートメソッド
    #-------------------------------

    private
        def create_remember_token
            self.remember_token = user.encrypt(user.new_remember_token)
        end

end


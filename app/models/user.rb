class User < ActiveRecord::Base

    #before_save はactiveRecordのコールバック
    #データベースのアダプタが常に大文字小文字を区別するインデックスを使っているとは限らないので、
    #保存するまえに小文字にする
    before_save {email.downcase!}

    validates :name, presence: true ,length: { maximum: 50 }
    # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    # uniqueness :true
    # 一意かどうか

    # uniqueness: {case_sensitive false}
    #　大文字小文字を無視した一意性の検証
    #  大文字と小文字で、同じメアドが来てもOKとする
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
        uniqueness: {case_sensitive:false}


    #パスワード関連
    #パスワードの存在検証と確認はhas_secure_passwordによって自動的に追加されます
    has_secure_password

    validates :password, length: { minimum: 6 }


end


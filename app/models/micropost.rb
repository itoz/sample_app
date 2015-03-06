class Micropost < ActiveRecord::Base
    #ユーザーテーブルとリレーション
    belongs_to :user

    #ラムダ式
    #　DESCは SQLでいうところの “descending” であり、新しいものから古い順への降順ということになります。
    default_scope -> { order("created_at DESC") }

    #ユーザーID
    validates :user_id, presence: true

    #コンテンツ文字数140文字まで
    validates :content, presence: true, length: {maximum: 140}

end

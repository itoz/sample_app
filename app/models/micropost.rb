class Micropost < ActiveRecord::Base

    #ユーザーテーブルとリレーション
    belongs_to :user

    #ラムダ式
    #　DESCは SQLでいうところの “descending” であり、新しいものから古い順への降順ということになります。
    default_scope -> { order("created_at DESC") }

    #コンテンツ文字数140文字まで
    validates :content, presence: true, length: {maximum: 140}

    #ユーザーID
    validates :user_id, presence: true


end

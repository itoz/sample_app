FactoryGirl.define do

    factory :user do
        #FacgoryGirlのsequenceメソッドを利用し一意の名前とメールを生成
        # n ブロックを置く
        sequence(:name)  { |n| "Person #{n}" }
        sequence(:email) { |n| "person_#{n}@example.com"}

        password "foobar"
        password_confirmation "foobar"

        factory :admin do
            admin true
        end

    end

    #以下のようにマイクロポスト用のファクトリーの定義にuserを含めるだけで、
    # マイクロポストに関連付けられるユーザーのことがFactory Girlに伝わります
    factory :micropost do
        content "Loren ipsum"
        user
    end

end

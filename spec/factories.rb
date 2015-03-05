FactoryGirl.define do

    factory :user do

        # name "Michael Hartl"
        # email "michael@example.om"

        #FacgoryGirlのsequenceメソッドを利用し一意の名前とメールを生成
        # n ブロックを置く
        sequence(:name)  { |n| "Person #{n}" }
        sequence(:email) { |n| "person_#{n}@example.com"}

        password "foobar"
        password_confirmation "foobar"



    end
end
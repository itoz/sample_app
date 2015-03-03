FactoryGirl.define do

    factory :user do
        name "Michael Hartl"
        email "michael@example.om"
        password "foobar"
        password_confirmation "foobar"
    end
end
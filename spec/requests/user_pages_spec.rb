require 'spec_helper'

describe "UserPages" do

  subject {page}


  #プロフィールページの表示
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    before {visit user_path(user)}
     it {should have_content(user.name)}
     it {should have_title(user.name)}

  end

  #サインアップページの表示
  describe "signup page" do
    before {visit signup_path}
    it {should have_content('Sign up')}
    it {should have_title(full_title("Sign up"))}
  end



  #サインアップ

  describe "signup" do


    before {visit signup_path}

    let(:submit) {"Create my account"}

    #登録の失敗
    describe "with invalid information" do
      it "should not create a user" do
        expect{click_button submit}.not_to change(User,:count)
      end
    end


    #登録の成功

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      #カウントが1ふえる
      it "should create a user" do
        # expect { click_button submit }.to change(User,:count).by(1)
        expect { click_button submit }.to change(User, :count).by(1)
      end


    end


  end

end

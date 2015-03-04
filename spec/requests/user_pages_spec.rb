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
      #エラーメッセージのテスト
      describe "after submission" do
        before {click_button submit}
        it {should have_title("Sign up")}
        it {should have_content("error")}
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

      #成功メッセージが表示されるか
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com") }
        it { should have_title(user.name) }
        it { should have_selector("div.alert.alert-success", text: "Welcome") }
      end
    end


  end

end

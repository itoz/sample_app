require 'spec_helper'

describe "UserPages" do

    subject { page }


    #プロフィールページの表示
    describe "profile page" do
        let(:user) { FactoryGirl.create(:user) }
        before { visit user_path(user) }
        it { should have_content(user.name) }
        it { should have_title(user.name) }

    end

    #サインアップページの表示
    describe "signup page" do
        before { visit signup_path }
        it { should have_content('Sign up') }
        it { should have_title(full_title("Sign up")) }
    end


    #サインアップ

    describe "signup" do


        before { visit signup_path }

        let(:submit) { "Create my account" }

        #登録の失敗
        describe "with invalid information" do
            it "should not create a user" do
                expect { click_button submit }.not_to change(User, :count)
            end
            #エラーメッセージのテスト
            describe "after submission" do
                before { click_button submit }
                it { should have_title("Sign up") }
                it { should have_content("error") }
            end

        end


        #サインアップの成功

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
                # 新規ユーザー登録後にユーザーがサインインしたことをテストする
                it { should have_link("Sign out") }
                it { should have_title(user.name) }
                it { should have_selector("div.alert.alert-success", text: "Welcome") }

            end


        end

        #編集ページ

        describe "edit" do

            let(:user) { FactoryGirl.create(:user) }
            before do
                sign_in user
                 visit edit_user_path(user)
            end


            describe "page" do
                #タイトルがあるか
                it { should have_content("Update your profile") }
                #タイトルがあるか
                it { should have_title("Edit user") }
                #グラバターリンクがあるか
                it { should have_link("change", href: "http://gravatar.com/emails") }
            end


            #編集の失敗
            describe "with invalid information" do
                before { click_button "Save changes" }
                it {should have_content("error")}
            end


            # ユーザーupdateアクションのテスト
            describe "with valid information" do
                let(:new_name) {"New Name"}
                let(:new_email) {"new@example.com"}
                before do

                    fill_in "Name" , with: new_name
                    fill_in "Email" , with: new_email
                    fill_in "Password" , with: user.password
                    fill_in "Confirm Password" , with: user.password
                    click_button "Save changes"

                end

                it {should have_title(new_name)}
                it {should have_selector("div.alert.alert-success")}
                it {should have_link("Sign out" , href: signout_path)}
                #変更後の名前が変更前のとイコールかどうか
                specify {expect(user.reload.name).to eq new_name}
                #変更後のMAILが変更前のとイコールかどうか
                specify {expect(user.reload.email).to eq new_email}

            end







        end

    end

end

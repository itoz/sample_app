require 'spec_helper'

describe "AuthenticationPages" do

  # describe "GET /authentication_pages" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get authentication_pages_index_path
  #     response.status.should be(200)
  #   end
  # end

  subject { page }

  #認証
  describe "Authentication" do
    before {visit signin_path}
    it{should have_content("Sign in")}
    it{should have_title("Sign in")}



    #承認
    describe "authorization" do

      #サインインしていないユーザーがいずれかのアクションにアクセスしようとしたときには、単にサインインページに移動することを確認
      describe "for non-signed-in users" do
        #ユーザー作成
        let(:user) { FactoryGirl.create(:user) }

        #ユーザーコントローラー
        describe "in the Users controller" do

          # エディットページに遷移
          describe "visiting the edit page" do
            before {visit edit_user_path(user)}
            #サインインページになるか確認
            it {should have_title("Sign in")}
          end

          #アップデート
          describe "submitting to the update action" do
            #visitではなくpatchメソッドを利用している
            #このリクエストはUsersコントローラのupdateアクションにルーティングされる
            #(訳注: updateは純粋に更新処理を行うアクションであって、そこで何かを表示するわけではないので)、
            # Capybaraでは対応できません。そして、editページを表示してもeditアクションの認可テストはできますが、
            # updateアクションの認可テストはできません。こうした事情から、
            # updateアクション自体をテストするにはリクエストを直接発行する以外に方法がないため
            before {patch user_path(user)}
            #特定　
            #patch get post delete を使うと、responseオブジェクトにアクセスできるようになる
            specify {expect(response).to redirect_to(signin_path)}

          end

        end

      end


      #他のユーザーがEditやUpdateにアクセス出来ないか確認
      describe "as wrong user" do
        #正しいユーザー
        let(:user) {FactoryGirl.create(:user)}
        #他のユーザー
        let(:wrong_user) {FactoryGirl.create(:user,email: "wrong@example.om")}
        #Capybaraをつかわないでサインインする
        before {sign_in user,no_capybara: true}

        #エディット
        describe "submitting a GET request to the Users#edit action" do
          before {get edit_user_path(wrong_user)}
          #タイトルがEditUserになっていないか確認
          specify {expect(response.body).not_to match(full_title("Edit User"))}
          #ルートURLにリダイレクトされるか確認
          specify {expect(response).to redirect_to(root_path)}
        end


        describe "submitting a PATCH request to the User#update action" do
          before {patch user_path(wrong_user)}
          #ルートURLにリダイレクトされるか確認
          specify {expect(response).to redirect_to(root_path)}
        end


      end

    end

  end



  #サインイン失敗のテスト
  describe "sign in" do

    before {visit signin_path}

    describe "with invalid information" do
      before {click_button "Sign in"}
      it {should have_title("Sign in")}
      it{should have_selector("div.alert.alert-error",text: "Invalid")}

      #失敗したあと、HOMEに戻ったら、エラーメッセージが表示されていないかどうか
      describe "after visiting another page" do
        before {click_link "Home"}
        it{should_not have_selector("div.alert.alert-error")}
      end
    end

    #サインイン成功
    describe "with valid information" do
      let(:user){FactoryGirl.create(:user)}

      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      it { should have_title(user.name) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link('Settings',href: edit_user_path(user)) }
      it { should have_link("Sign out",href: signout_path) }
      it { should_not have_link("Sign in", href: signin_path) }

      #ユーザーのサインアウトをテストする。
      describe "followed by signout" do
        before {click_link "Sign out"}
        it{should have_link("Sign in")}
      end
    end
  end
end

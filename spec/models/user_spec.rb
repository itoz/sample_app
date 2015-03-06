require 'spec_helper'

describe User do

  before do
    @user=User.new(name: "Example User", email: "user@example.com", password: "foobar" , password_confirmation: "foobar")
  end

  subject {@user}

  it{should respond_to(:name)}
  it{should respond_to(:email)}
  it{should respond_to(:password_digest)}
  it{should respond_to(:password)}
  it{should respond_to(:password_confirmation)}
  it{should respond_to(:remember_token)}
  it{should respond_to(:authenticate)}
  it{should respond_to(:admin)}

  it{should respond_to(:microposts)}
  it { should be_valid }
  it { should_not be_admin }

  #---------------------
  # アドミンユーザーの確認
  #---------------------
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name=" " }
    it { should_not be_valid }

  end

  #メアド存在確認

  describe "when email is not present" do
    before { @user.email =" " }
    it { should_not be_valid }
  end

  #名前存在確認
  describe "when name is too long" do
    before { @user.name ="a"*51 }
    it { should_not be_valid }
  end

  #パスワード存在確認

  describe "when password is not present" do

    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: " " , password_confirmation: " ")
    end
    it {should_not be_valid}
  end


  #パスワードとパスワード確認が一致するか

  describe "when password doesn't match confirmation" do

    before {@user.password_confirmation = "mismatch"}
    it {should_not be_valid}

  end



  #パスワードが一致する場合と一致しない場合
  describe "return value of authenticate method" do
    before {@user.save}
    #emailからユーザーを抽出
    let(:found_user) {User.find_by(email: @user.email)}
    #一致
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    #パスワード不一致
    describe "with invalid password" do
      let(:user_for_invalid_password) {found_user.authenticate("invalid")}
      it{should_not eq user_for_invalid_password}
      #特定
      specify {expect(user_for_invalid_password).to be_false}
    end
  end


  #短すぎるパスワード

  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should be_invalid}
  end

  #ユーザーの電子メールの形式が無効です
  # > 無効なメールアドレスを弾くかどうか
  describe "when email format is invalid" do

    #無効であるべき
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
        foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalide_address|
        @user.email = invalide_address
        expect(@user).not_to be_valid
      end
    end
  end

  #有効なアドレスが通るか
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email  = valid_address
        expect(@user).to be_valid
      end
    end
  end


  #混在ケースと電子メールアドレスを記述
  # メールアドレスが小文字に変換されるか
  describe "email address with mixed case" do
    let (:mixed_case_email) {"Foo@ExAmple.CoM"}
    #それはすべて小文字として保存する必要があります
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase

    end


  end

  #記憶トークンが有効である (空欄のない) ことをテストする
  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end


  #大文字小文字を区別しない、重複するメールアドレスの拒否のテスト
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end



  #マイクロポスト関連

  describe "microposts associations" do



    before {@user.save}

    #let変数はlazy、つまり参照されたときにはじめて初期化されるため
    # !をつける
    #ここでは、マイクロポストを遅延することなく即座に作成する必要があります
    #タイムスタンプが常に正しい順序で作成されるように
    # かつ、
    #@user.micropostsが空の状態が生じることのないように
    #let!を使用すれば、対応する変数を強制的に即座に作成できます。
    let! (:older_micropost) do
      FactoryGirl.create(:microposts,user: @user,created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:microposts,user: @user,created_at: 1.hour.ago)
    end

    #
    # 新しいポストが最初に来るか
    #
    it "should have the right microposts in the right order" do
      #to_aで、Active Recordの "collection proxy" から、配列に変換している
      expect(@user.microposts.to_a).to eq [newer_micropost,older_micropost]

    end

    #
    # ユーザーが破棄されたらmicropostも破棄されるか
    #  関連したマイクロポストを破棄する必要がある
    #
    it "should destroy associated microposts" do

      #マイクロソフトのコピーを保持しておく
      microposts = @user.microposts.to_a
      #ユーザー削除
      @user.destroy
      #コピーが存在することを確認
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        # マイクロポストIDでデータベースを検索し、なくなったことを確認
        #whereメソッドは、レコードがない場合に空のオブジェクトを返すので多少テストが書きやすくなる
        expect(Micropost.where(id: micropost.id)).to be_empty
      end

    end


    #
    # プロフィールページ
    #
    describe "profile page" do

      #ユーザー作成
      let(:user) {FactoryGirl.create(:user)}
      #マイクロソフト作成
      let!(:m1) {FactoryGirl.create(:microposts,user: user,content: "hoge")}
      let!(:m2) {FactoryGirl.create(:microposts,user: user,content: "fuga")}


      #ユーザーページアクセス
      before {visit user_path(user)}

      it {should have_content(m1.content)}
      it {should have_content(m2.content)}
      it {should have_content(user.microposts.count)}

    end

  end



end

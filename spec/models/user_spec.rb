require 'spec_helper'

describe User do

  # pending "add some examples to (or delete) #{__FILE__}"

  before do
    @user=User.new(name: "Example User", email: "user@example.com", password: "foobar" , password_confirmation: "foobar")
    # @user=User.new(name: "Example User", email: "user@example.com")
  end

  subject {@user}

  it{should respond_to(:name)}
  it{should respond_to(:email)}
  it{should respond_to(:password_digest)}
  it{should respond_to(:password)}
  it{should respond_to(:password_confirmation)}
  it{should respond_to(:authenticate)}


  it {should be_valid}

  describe "when name is not present" do
    before {@user.name=" "}
    it {should_not be_valid}

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

  #無効なメールアドレスを弾くかどうか

  describe "when email format is invalid" do

    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
        foo@bar_baz.com foo@bar+baz.com]
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

  #大文字小文字を区別しない、重複するメールアドレスの拒否のテスト
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

end

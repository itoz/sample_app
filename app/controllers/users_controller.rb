class UsersController < ApplicationController


    #----------------------------
    # Index/Edit/Updateへのアクセスはサインインが必要。
    #----------------------------
    #サインインの確認。サインイン指定なければ、サインインページにリダイレクト。
    #EditとUpdate時は、ユーザーにサインインを要求するために
    #signed_in_userメソッドを定義してbefore_action :signed_in_userという形式で呼び出します
    before_action :signed_in_user, only: [:index,:edit, :update]


    #----------------------------
    # Edit/Updateは正しいユーザーのアクセスかチェック、
    #----------------------------
    #サインインしているが正しくないユーザーの場合、ルートへリダイレクト
    #このbeforeアクション内で、@user = User.find(params[:id])　が実行されるので、edit update内でその記述は必要ない
    before_action :correct_user, only:[:edit ,:update]


    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def new
        @user = User.new
    end


    def edit
    end


    def update
        @user = User.find(params[:id])
        #attributesをチェックすることにより、更新にはパスワードが必ず要求されるようになる
        if @user.update_attributes(user_params)
            #更新に成功した場合
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            render "edit"
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save
            #-------------
            # 作成/保存の成功
            #-------------

            #サインイン
            sign_in @user
            flash[:success] = "Welcome to the Sample App!"

            #リダイレクト
            redirect_to @user

        else
            render 'new'
        end
    end


    #--------------------
    # private actions
    #--------------------


    private

        #Strong Parameter
        def user_params
            params.require(:user).permit(:name,:email,:password,:password_confirmation)
        end

        #--------------------
        # before action
        #--------------------
        #Edit,Update時のサインインしていない場合のリダイレクト
        def signed_in_user
            #signed_inはsession_helperに定義されている
            unless signed_in?
                #フレンドリーフォワーディングのため、
                # アクセスされたURLをRailsのsession機能に保存しておく
               store_location
               flash[:notice] = "Please sign in."
                redirect_to signin_url
            end
        end

        # 正しいユーザーか
        def correct_user
            @user = User.find(params[:id])
            #current_user?はsession_helper.rbにある
            redirect_to(root_path) unless current_user?(@user)
        end
end

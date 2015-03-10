class MicropostsController< ApplicationController

    before_action :signed_in_user
    before_action :correct_user ,only: :destroy

    def create

        @micropost = current_user.microposts.build(micropost_params)
        #dbに保存
        if @micropost.save
            flash[:success]  ="Micropsost created!"
            redirect_to root_url
        else
            @feed_items=[]
            render "static_pages/home"
        end
    end

    def destroy
        @micropost.destroy
        redirect_to root_url
    end


    #----------------------------
    # private
    #----------------------------
    private

        #Strong Parameters
        def micropost_params
            params.require(:micropost).permit(:content)
        end

        def correct_user
            #親ユーザーがMicropostIDをもっているか？
            #これによって、カレントユーザーに所属するマイクロポストだけが自動的に見つかることが保証されます。
            #findではなくfind_byをつかっているのは、findだと見つからない場合例外が発生するが、find_byだとnilがかえるため
            @micropost = current_user.microposts.find_by(id: params[:id])
            redirect_to root_url if @micropost.nil?
            #下記のような書き方はセキュリティ的によろしくない？
            # todo 何故か理解する
            # redirect_to root_url unless current_user?(@micropost.user)
        end
end
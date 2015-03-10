class StaticPagesController < ApplicationController

  def home
    #@micropostを定義する
    @micropost = current_user.microposts.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end

end

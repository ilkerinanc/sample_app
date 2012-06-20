class MicropostsController < ApplicationController
  before_filter :signed_in_user,   only: [:create, :destroy]
  before_filter :correct_user,    only: :destroy


  def create
    @micropost = current_user.microposts.build(params[:micropost])

    if @micropost.content =~ /^@\w+/
      reply_to_username = @micropost.content.scan(/\w+/).first
      if User.find_by_username(reply_to_username)
        @micropost.in_reply_to = User.find_by_username(reply_to_username).id
      end
    end

    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
    #  redirect_to root_path
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
end
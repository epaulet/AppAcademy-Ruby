class PostsController < ApplicationController
  before_action :ensure_author, only: [:edit, :update]
  before_action :ensure_logged_in, only: [:new]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @subs = Sub.all
    @post = Post.new(post_params)
    @post.author_id = current_user.id
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    @subs = Sub.all

    if @post.save
      flash.notice = "post succesfully created"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @subs = Sub.all
  end

  def update
    if @post.update(post_params)
      flash.notice = "post succesfully edited"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

  def ensure_author
    @post = Post.find(params[:id])
    unless @post.is_author?(current_user)
      flash.notice = "You are not the author of this post"
      redirect_to post_url(@post)
    end
  end
end

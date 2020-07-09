class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @blogs = Blog.all
  end

  def show
  end

  def new
    if logged_in?
      @blog = Blog.new
    else
      redirect_to new_session_path
    end
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog.id), notice: '投稿が完了しました。' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: blogs_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blogs_path, notice: '更新が完了しました' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'ブログを削除しました。' }
      format.json { head :no_content }
    end
  end

  def ensure_correct_user
    @blog = Blog.find_by(id:params[:id])
    if @blog.user_id != current_user.id
      flash[:notice] = "ログインしてください"
      redirect_to new_session_path
    end
  end

  private
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:title, :content).merge(user_id: current_user.id)
    end
end

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    setup_form_options
  end

  def edit
    setup_form_options
    @post = Post.find(params[:id])
    @comments = @post.comments
    @post.comments.build
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    setup_form_options
    if @post.save
      flash[:success] = "Good job."
      redirect_to post_path(@post)
    else
      flash.now = "oops."
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    setup_form_options
    if @post.update(post_params)
      flash[:sucess] = "It saved the update."
      redirect_to post_path(@post)
    else
      flash.now[:error] = "It did not save the update. #{@post.errors.full_messages.join}"
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id, :parent_post, 
                                  :tag_ids => [],
                                   :comments_attributes => 
                                      [:id, :body, :_destroy] )
  end

  def setup_form_options
    @category_options = Category.all.map { |c| [c.name, c.id]} << ['n/a', 'na']
    @tag_options = Tag.all.map{ |t| [t.name, t.id]}
  end
end

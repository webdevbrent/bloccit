class PostsController < ApplicationController
  before_action :require_sign_in, except: :show
  # Check role of signed-in user. If current_user isn't autorized based on role. Redirect to post show view
  before_action :authorize_user_to_update, except: [:show, :new, :create, :destroy]
  before_action :authorize_user_to_delete, except: [:show, :new, :create, :edit, :update]
  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = 'Post was saved.'
      redirect_to [@topic, @post]
    else
      flash.now[:alert] = 'There was an error saving the post. Please try again.'
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)

    if @post.save
      flash[:notice] = 'Post was updated.'
      redirect_to [@post.topic, @post]
    else
      flash.now[:alert] = 'There was an error saving the post. Please try again.'
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:notice] = "\"#{@post.title}\" was deleted successfully."
      redirect_to @post.topic
    else
      flash.now[:alert] = 'There was an error deleting this post.'
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  # Redirect the user unless they own the post they are attempting to modify or they are an admin
  def authorize_user_to_update
    post = Post.find(params[:id])
    unless current_user == post.user || current_user.admin? || current_user.moderator?
      flash[:alert] = 'You must be an admin to do that!'
      redirect_to [post.topic, post]
    end
  end

  def authorize_user_to_delete
    post = Post.find(params[:id])
    unless current_user == post.user || current_user.admin?
      flash[:alert] = 'You must be an admin to do that!'
      redirect_to [post.topic, post]
    end
  end

end

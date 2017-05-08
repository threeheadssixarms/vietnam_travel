class CommentsController < ApplicationController
  before_action :load_image
  before_action :load_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @image.main_comments
    unless @comments.empty?
      comment_offset = params[:comment_offset] || (@comments.first.id + 1)
      @comments = @comments.where("id < ?", comment_offset)
        .limit Settings.load_more_comment_size
    end
    @last = (@comments.size < Settings.load_more_comment_size) ? true : false
  end

  def new
  end

  def create
    @comment = Comment.new comment_params
    @comment.image = @image
    @comment.user = current_user
    @success = @comment.save
  end

  def edit
  end

  def update
    @comment.update_attributes comment_params
  end

  def destroy
    @comment.destroy
    @comments = @image.main_comments
    unless @comments.empty?
      comment_offset = params[:comment_offset] || (@comments.first.id + 1)
      @comments = @comments.where("id < ?", comment_offset)
        .limit Settings.load_more_comment_size
    end
    @last = (@comments.size < Settings.load_more_comment_size) ? true : false
  end

  private
  def comment_params
    params.require(:comment).permit :reply_id, :content, :parent_id
  end

  def load_image
    @image = Image.find_by id: params[:image_id]
    unless @image
      flash[:danger] = "写真は存在じゃない。"
      redirect_to root_path
    end
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    unless @comment
      flash[:danger] = "コメントは存在じゃない。"
      redirect_to root_path
    end
  end
end

module Spree
  class Admin::PostsController < Admin::ResourceController
    
    #cache_sweeper PostSweeper, :only => [ :edit, :update, :destroy ]
    
    def index
     @posts = Post.page(params[:page])
    end
    
    def new
      @post = Post.new
    end
    
    def create
      @post = Post.new(params[:post])
      if @post.save
        flash[:notice] = "Successfully created post."
        redirect_to admin_posts_url
      else
        render :action => 'new'
      end
    end
    
    def edit
      @post = Post.find(params[:id])
    end
    
    def update
      @post = Post.find(params[:id])
      if @post.update_attributes(params[:post])
        flash[:notice] = "Successfully updated post."
        redirect_to admin_posts_url
      else
        render :action => 'edit'
      end
    end
    
    def destroy
      @object = Post.find(params[:id])
      invoke_callbacks(:destroy, :before)
      if @object.destroy
        invoke_callbacks(:destroy, :after)
        flash.notice = flash_message_for(@object, :successfully_removed)
        respond_with(@object) do |format|
          format.html { redirect_to admin_posts_url }
          format.js   { render :partial => "spree/admin/shared/destroy" }
        end
      else
        invoke_callbacks(:destroy, :fails)
        respond_with(@object) do |format|
          format.html { redirect_to admin_posts_url }
        end
      end
    end
    
    def current_order

    end
  end
end

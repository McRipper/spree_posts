module Spree
  class PostsController < BaseController
    before_filter { render_404 if params[:id] =~ /(\.|\\)/ }

    caches_action :show, :if => Proc.new { Config[:cache_static_content] }, :layout => false

    respond_to :html

    def index
      if params[:tag]
        @posts = Post.published.tagged_with(params[:tag]).page(params[:page]).per(4)
      else
        @posts = Post.published.page(params[:page]).per(4)
      end
      sidebar
    end

    # GET /pages/about-us
    def show
      @post = Post.published.find_by_permalink(params[:id])
      sidebar
    end

    def current_order
    end

    def find_by_archive
      sidebar
      @year = params[:year]
      @month = Date::MONTHNAMES[params[:month].to_i]
      @posts = Post.archives(params[:year].to_i, params[:month].to_i).page(params[:page]).per(4)
    end

    private
    def sidebar
      @categories = Post.published.tag_counts
      @archive    = Post.published.group_by{ |x| x.published_at.year }.map{ |k, v| [ k, v.group_by{ |x| x.published_at.month }.map{|k,v| [k,v.count] } ] }
    end

  end
end

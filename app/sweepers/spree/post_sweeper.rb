module Spree
  class PostSweeper < ActionController::Caching::Sweeper
    observe post

    def after_update(post)
      expire_post_cache(post)
    end

    def after_destroy(post)
      expire_post_cache(post)
    end

  private

    def expire_post_cache(post)
      expire_action(:controller => 'posts', :action => 'show', :id => post.permalink)
    end

  end
end

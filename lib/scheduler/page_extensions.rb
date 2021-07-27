module Scheduler::PageExtensions
  include Radiant::Taggable

  def self.included(base)
    base.extend ClassMethods
    class << base
      alias_method_chain :find_by_path, :scheduling
    end
  end

  module ClassMethods
    def find_by_path_with_scheduling(url, live=true)
      if live
        self.with_published_only do
          find_by_path_without_scheduling(url, live)
        end
      else
        find_by_path_without_scheduling(url, live)
      end
    end

    def with_published_only
      with_scope(:find => {:conditions => ["(`pages`.appears_on IS NULL OR `pages`.appears_on <= ?) AND (`pages`.expires_on IS NULL OR `pages`.expires_on > ?)", lambda{Date.today}.call, lambda{Date.today}.call]}) do
        yield
      end
    end
  end

  tag 'children' do |tag|
    tag.locals.children = tag.locals.page.children
    if dev?(tag.globals.page.request)
      tag.expand
    else
      Page.with_published_only do
        tag.expand
      end
    end
  end
end

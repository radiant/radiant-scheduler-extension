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
      if @with_published
        yield
      else
        @with_published = true
        result = with_scope(:find => {:conditions => ["(appears_on IS NULL OR appears_on <= ?) AND (expires_on IS NULL OR expires_on > ?)", lambda{Date.today}.call, lambda{Date.today}.call]}) do
          yield
        end
        @with_published = false
        result
      end
    end
  end

  def visible?
    published? && appeared? && !expired?
  end

  def appeared?
    appears_on.blank? || appears_on <= Date.today
  end

  def expired?
    !expires_on.blank? && self.expires_on < Date.today
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

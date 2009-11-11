module Scheduler::ControllerExtensions
  def self.included(base)
    base.class_eval { around_filter :filter_with_scheduler }
  end

  protected
  def filter_with_scheduler
    if live?
      Page.with_published_only { yield }
    else
      yield
    end
  end
end

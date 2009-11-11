module Scheduler::ControllerExtensions
  def self.included(base)
    base.class_eval { around_filter :filter_with_scheduler, :if => :live? }
  end

  protected
  def filter_with_scheduler
    Page.with_published_only { yield }
  end
end

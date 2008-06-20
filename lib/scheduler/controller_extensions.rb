module Scheduler::ControllerExtensions
  def self.included(base)
    base.class_eval { alias_method_chain :process_page, :scheduling }
  end
  
  def process_page_with_scheduling(page)
    if live?
      Page.with_published_only { process_page_without_scheduling(page) }
    else
      process_page_without_scheduling(page)
    end
  end
end
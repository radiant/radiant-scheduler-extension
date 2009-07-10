# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class SchedulerExtension < Radiant::Extension
  version "0.2"
  description "Allows setting of appearance and expiration dates for pages."
  url "http://dev.radiantcms.org"
    
  def activate
    Page.send :include, Scheduler::PageExtensions
    SiteController.send :include, Scheduler::ControllerExtensions
    admin.pages.edit.add :extended_metadata, "edit_scheduler_meta"
  end
end

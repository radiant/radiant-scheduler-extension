# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

require 'radiant-scheduler-extension'

class SchedulerExtension < Radiant::Extension
  version RadiantSchedulerExtension::VERSION
  description RadiantSchedulerExtension::DESCRIPTION
  url RadiantSchedulerExtension::URL
    
  def activate
    Page.send :include, Scheduler::PageExtensions
    SiteController.send :include, Scheduler::ControllerExtensions
    admin.pages.edit.add :extended_metadata, "edit_scheduler_meta"
  end
end

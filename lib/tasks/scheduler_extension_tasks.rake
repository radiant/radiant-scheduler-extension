namespace :radiant do
  namespace :extensions do
    namespace :scheduler do
      
      desc "Runs the migration of the Scheduler extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          SchedulerExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          SchedulerExtension.migrator.migrate
        end
      end
    
      desc "Copies Scheduler extension assets to the public directory."
      task :update => :environment do
        ext_js_dir = SchedulerExtension.root + "/public/javascripts"
        Dir[ext_js_dir + "/*.js"].each do |file|
          puts "Copying #{File.basename(file)}..."
          cp file, RAILS_ROOT + "/public/javascripts"
        end
      end
    end
  end
end
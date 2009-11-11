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
      
      desc "Copies public assets of the Scheduler to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from SchedulerExtension"
        Dir[SchedulerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(SchedulerExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end

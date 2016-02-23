namespace :test do
  desc 'Test ForemanNameGenerator'
  Rake::TestTask.new(:foreman_name_generator) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
  end
end

namespace :foreman_name_generator do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_name_generator) do |task|
        task.patterns = ["#{ForemanNameGenerator::Engine.root}/app/**/*.rb",
                         "#{ForemanNameGenerator::Engine.root}/lib/**/*.rb",
                         "#{ForemanNameGenerator::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_name_generator'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:foreman_name_generator'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance do
    Rake::Task['test:foreman_name_generator'].invoke
    Rake::Task['foreman_name_generator:rubocop'].invoke
  end
end

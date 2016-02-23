module ForemanNameGenerator
  class Engine < ::Rails::Engine
    engine_name 'foreman_name_generator'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    initializer 'foreman_name_generator.load_default_settings', :before => :load_config_initializers do |app|
      require_dependency File.expand_path("../../../app/models/setting/name_generator.rb", __FILE__) if (Setting.table_exists? rescue(false))

      if (Setting['name_generator_seed'] && Setting['name_generator_seed'] < 1) || (Setting['name_generator_register'] && Setting['name_generator_register'] < 1)
        initial = ForemanNameGenerator::RandomGenerator.random_initial_seed
        Rails.logger.info "Name Generator initialized seed to #{initial}"
        Setting['name_generator_seed'] = initial
        Setting['name_generator_register'] = initial
      end
    end

    initializer 'foreman_name_generator.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_name_generator do
        requires_foreman '>= 1.10'
      end
    end

    config.to_prepare do
      ::Host::Managed.send(:include, ForemanNameGenerator::HostExtensions)
      ::SettingsHelper.send :include, ForemanNameGenerator::SettingsHelperExtensions
    end

    initializer 'foreman_name_generator.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_name_generator'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end

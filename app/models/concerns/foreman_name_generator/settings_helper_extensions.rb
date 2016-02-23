module ForemanNameGenerator
  module SettingsHelperExtensions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :value, :name_generator
    end

    def value_with_name_generator(setting)
      return value_without_name_generator(setting) unless ['name_generator_type'].include?(setting.name)

      case setting.name
      when "name_generator_type"
        edit_select(setting, :value, {:select_values => {
          'OFF' => "OFF",
          'MAC+RANDOM' => "MAC+RANDOM",
          'MAC' => "MAC",
          'RANDOM' => "RANDOM"
        }.to_json})
      end
    end
  end
end

module ForemanNameGenerator
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      attr_accessor :generated_random_name
      before_validation :generate_name
    end

    def generate_name
      if (self.name.nil? || self.name.empty?) && new_record? && (Setting['name_generator_type'] == 'MAC' || Setting['name_generator_type'] == 'MAC+RANDOM')
        generator = ForemanNameGenerator::MacGenerator.new
        self.name = generator.generate(self.mac).join('-').downcase
      end
      if (self.name.nil? || self.name.empty?) && new_record? && (Setting['name_generator_type'] == 'RANDOM' || Setting['name_generator_type'] == 'MAC+RANDOM')
        self.generated_random_name = self.name = Setting::NameGenerator.next_generated_name.join('-').downcase
      end
    end
  end
end

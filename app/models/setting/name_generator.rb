require 'monitor'

class Setting::NameGenerator < ::Setting
  NAME_GENERATOR_MUTEX = Mutex.new

  def self.load_defaults
    # Check the table exists
    return unless super

    Setting.transaction do
      [
        self.set('name_generator_type', N_("Type of name generator"), 'OFF', N_("Generator type")),
        self.set('name_generator_seed', N_("Initial LFSR seed value (do not change)"), -1, N_("Generator seed")),
        self.set('name_generator_register', N_("Current LFSR register (change with care, can cause name conflicts)"), -1, N_("Generator register")),
      ].compact.each { |s| self.create s.update(:category => "Setting::NameGenerator")}
    end

    true
  end

  def validate_name_generator_seed(record)
    if record.value && record.value < 1 && record.value != -1
      record.errors[:base] << _("Generator seed value must be greater than zero or -1")
    end
  end

  def self.next_generated_name
    NAME_GENERATOR_MUTEX.synchronize do
      generator = ForemanNameGenerator::RandomGenerator.new
      setting = Setting::NameGenerator.find_by_name 'name_generator_register'
      result = generator.generate(setting.value)
      Rails.logger.debug "Register moved to #{result[0]}, generated name: #{result[1]} #{result[2]}"
      setting.value = result.shift
      setting.save!
      result
    end
  end
end

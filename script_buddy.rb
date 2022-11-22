module ScriptBuddy

  # === CONSTANTS ===

  # init ENV vars from config if present
  if File.exist?('.config/development.rb')
    require_relative '.config/development.rb'
  end

  # convert ENV vars into constants for convenience
  def init_constants_from_env(names)
    names.each do |name|
      raise "#{name} not found" unless ENV[name]
      ScriptBuddy.const_set name, ENV[name].freeze
    end
  end

end

# frozen_string_literal: true

require "debug"

Dir[File.join(__dir__, "../lib/**/*.rb")].each do |file|
  require file
end

# frozen_string_literal: true

require './app/tpoutcut'

Version = '0.1.0' # rubocop:disable Naming/ConstantName

tpoutcut = Tpoutcut.new
exit tpoutcut.run

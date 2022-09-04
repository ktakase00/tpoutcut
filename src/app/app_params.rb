# frozen_string_literal: true

require './app/command_args'
require './app/config'

# 実行のためのパラメータを準備する。
class AppParams
  def self.load
    config = load_config
    input_path = retrieve_input_path
    new(config: config, input_path: input_path)
  end

  def self.load_config
    command_args = CommandArgs.read
    Config.load(command_args.config)
  end

  def self.retrieve_input_path
    ARGV[0]
  end

  attr_reader :config, :input_path

  def initialize(config:, input_path: nil)
    @config = config
    @input_path = input_path
  end
end

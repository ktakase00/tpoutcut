# frozen_string_literal: true

require 'optparse'

# コマンドライン引数の解析結果。
class CommandArgs
  attr_reader :config

  def self.read
    opt = make_option_parser
    options = {}
    opt.parse!(ARGV, into: options)
    new(**options)
  end

  def self.make_option_parser
    opt = OptionParser.new
    opt.banner = 'Usage: tpoutcut [options] [input_file]'
    opt.on('-c', '--config=CONFIG_FILE', 'configuration file path') { |value| value }
    opt.separator('')
    opt.on('    input_file                       file path of typeprof result')
    opt.separator('')
    opt
  end

  private_class_method :make_option_parser

  def initialize(config: nil)
    @config = config
  end
end

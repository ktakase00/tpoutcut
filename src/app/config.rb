# frozen_string_literal: true

require 'yaml'

# 設定内容。
class Config
  attr_reader :section, :excludes

  def self.load(file_path)
    return new(**make_default_hash) if file_path.nil?

    file_content = File.open(file_path, 'rb:utf-8', &:read)
    hash = YAML.safe_load(file_content, symbolize_names: true)
    new(**hash)
  end

  def self.make_default_hash
    { section: 'Errors', excludes: [] }
  end

  def initialize(section: nil, excludes: nil)
    default = self.class.make_default_hash

    @section = section || default[:section]
    @excludes = (excludes || default[:excludes]).map(&:to_s)
  end
end

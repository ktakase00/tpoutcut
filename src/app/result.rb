# frozen_string_literal: true

# 入力ファイルの内容読み取り中の状態。
class Result
  attr_reader :status, :section, :contents

  def initialize(config:)
    @config = config
    @status = 'init'
    @section = nil
    @contents = []
    @regexps = config.excludes.map { |re_str| Regexp.new(re_str) }
  end

  def update(line)
    case line
    when /^# (.+)/
      change_section(Regexp.last_match(1)) if %w[init blank].include?(@status)

    when /^$/
      @status = 'blank' if %w[title content].include?(@status)

    else
      @status = 'content' if @status == 'title'
      store_content(line)
    end
  end

  private

  def change_section(section)
    @section = section
    @status = 'title'
  end

  def store_content(line)
    return unless @section == @config.section

    if @regexps.empty?
      @contents.push(line)
      return
    end

    match_flag = @regexps.any? { |regexp| regexp.match?(line) }
    @contents.push(line) unless match_flag
  end
end

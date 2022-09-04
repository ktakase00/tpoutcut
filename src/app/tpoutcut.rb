# frozen_string_literal: true

require './app/app_params'
require './app/result'
require './app/input_file'

# typeprof の出力結果から、対象のセクションの内容を取り出す。
class Tpoutcut
  def run
    app_params = AppParams.load
    result = make_result(app_params)

    puts result.contents

    make_exit_code(result)
  end

  private

  def make_result(app_params)
    result = Result.new(config: app_params.config)

    InputFile.open(app_params.input_path) do |file|
      file.each do |line|
        line.gsub!(/[\r\n]*$/, '')
        result.update(line)
      end
    end

    result
  end

  def make_exit_code(result)
    result.contents.empty? ? 0 : 1
  end
end

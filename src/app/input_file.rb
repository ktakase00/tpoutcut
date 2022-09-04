# frozen_string_literal: true

# 標準入力か、または指定されたファイルを入力とする。
class InputFile
  def self.open(file_path, &block)
    file_handle = make_file_handle(file_path)
    instance = new(file_handle: file_handle, file_path: file_path)

    return instance.execute(block) if block_given?

    instance
  end

  def self.make_file_handle(file_path)
    # nil 判定しているが、undefined method: nil#empty? のエラーになるので &. にしておく。
    if file_path.nil? || file_path&.empty?
      $stdin
    else
      File.open(file_path, 'rb:utf-8')
    end
  end

  private_class_method :make_file_handle

  def initialize(file_handle:, file_path: nil)
    @file_handle = file_handle
    @file_path = file_path
  end

  def execute(block_to_file)
    block_to_file.call(@file_handle)
  ensure
    close
  end

  def each(&block_to_line)
    @file_handle.each if !block_given? || block_to_line.nil?

    @file_handle.each do |line|
      # nil 判定しているが、undefined method: nil#call のエラーになるので &. にしておく。
      block_to_line&.call(line)
    end
  end

  def close
    @file_handle&.close unless @file_path.nil?
  end
end

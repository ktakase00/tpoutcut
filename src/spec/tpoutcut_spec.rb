# frozen_string_literal: true

require 'rspec'
require './app/tpoutcut'

RSpec.describe 'Tpoutcut' do
  subject do
    Tpoutcut.new
  end

  let(:stub_input_path) do
    allow(AppParams).to receive(:retrieve_input_path).and_return('./sample/sample01.txt')
  end

  let(:stub_config) do
    allow(AppParams).to receive(:load_config) do
      Config.load('./sample/sample01.yaml')
    end
  end

  before do
    stub_input_path
  end

  shared_examples 'execute tpoutcut' do
    it '成功すること' do
      expect(subject.run).to eq(expected)
    end
  end

  describe 'エラーの出力に' do
    let(:expected) { 1 }

    include_examples 'execute tpoutcut'
  end

  describe '除外対象の抑制に' do
    before do
      stub_config
    end

    let(:expected) { 0 }

    include_examples 'execute tpoutcut'
  end
end

# tpoutcut

## 概要

Ruby typeprof コマンドの実行結果から、Errors セクションの内容を取り出します。

設定ファイルで出力を抑制する正規表現パターンを指定することで、検出したくないエラーを除外することができます。

<br>

typeprof の実行結果が以下のような内容であったとします。

```
# TypeProf 0.21.3

# Errors
app/config.rb:13: [error] undefined method: singleton(YAML)#safe_load
app/config.rb:14: [error] unknown keyword: 
app/result.rb:11: [warning] inconsistent assignment to RBS-declared variable

# Classes
class Config
# def self.load: (String file_path) -> Config
# def self.make_default_hash: -> {section: String, excludes: Array[String]}
# attr_reader excludes: Array[String]
# attr_reader section: String
  def initialize: (?section: String?, ?excludes: Array[String]?) -> void
end
  :
```

このうち、`Errors` セクションの内容だけが取り出されます。

```
$ typeprof --show-errors typeprof.rbs app/*.rb | ruby tpoutcut.rb
app/config.rb:13: [error] undefined method: singleton(YAML)#safe_load
app/config.rb:14: [error] unknown keyword: 
app/result.rb:11: [warning] inconsistent assignment to RBS-declared variable
```

出力内容がある場合、終了コードが `1` になります。これにより、typeprof の解析でエラーが検出されたことを知ることができます。

```sh
echo $?
1
```

<br>

## 使い方

### ヘルプの内容

```
$ ruby tpoutcut.rb --help
Usage: tpoutcut [options] [input_file]
    -c, --config=CONFIG_FILE         configuration file path

    input_file                       file path of typeprof result

```

コマンドライン引数でファイル名が省略された場合、標準入力で与えられた内容に対して処理を行います。

<br>

### 実行例

**実行の例**

`tpoutcut` のリポジトリが `~/projects` にあるとします。

```sh
PATH=$PATH:~/projects/tpoutcut/bin

typeprof --show-errors typeprof.rbs app/*.rb | tpoutcut --config "$(pwd)/tpoutcut.yaml"
```

**実行結果の例**

```
app/main.rb:52: [error] wrong number of arguments (given 2, expected 3)
```

<br>

### 注意事項

- `--config` には設定ファイルのパスを指定します。パスは絶対パスで指定してください。

<br>

## 設定ファイル

**ファイル形式**

YAML の書式で記述します。

**ファイルの例**

```yaml
section: Errors
excludes:
  - '\[warning\]'
  - 'undefined method: singleton\(YAML\)#safe_load'
```

**キーの説明**

|キー|型|値|デフォルト値|
|---|---|---|---|
|section|String|typeprof の実行結果のうち、どのセクションを取り出すかを指定します。|Errors|
|excludes|Array[String]|typeprof の実行結果のうち、出力を抑制する行の正規表現パターンを指定します。|[]|

**補足**

設定ファイルを指定しない場合は、デフォルト値の設定で動作します。

<br>

## 終了コード

|コード|意味|
|---|---|
|0|出力する内容がなかったことを表します。|
|1|出力内容があったことを表します。例えば、Errors セクションを出力対象とした場合、エラーがあったことになります。|

<br>

## 開発時のバージョン

|言語など|バージョン|
|---|---|
|Ruby|3.1.2|
|typeprof|0.21.3|

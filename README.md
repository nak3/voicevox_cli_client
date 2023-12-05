# VOICEVOX CLI Client

[VOICEVOX ENGINE](https://github.com/VOICEVOX/voicevox_engine)、[VOICEVOX NEMO ENGINE](https://github.com/VOICEVOX/voicevox_nemo_engine)、[COEIROINK](https://coeiroink.com/) (※COEIROINKv2には未対応です)用のコマンドラインツールです。

# 機能

VOICEVOX ENGINE、VOICEVOX NEMO ENGINEまたは、COEIROINK ENGINEを利用して、テキストを音声ファイルにしたり再生することができます。

テキスト内にある空行を区切りとして、別々の音声ファイルに保存されます。一つの音声ファイルにまとめて出力することも可能です。

また、テキスト内の文章の先頭に決まった書式で記述することで、その部分以降の読み上げパラメータ(音声種別や速度など)を変更することができます。

複数のVOICEVOX ENGINE、VOICEVOX NEMO ENGINE、COEIROINK ENGINEを設定することで、並列で音声変換が実行できます。(句点、改行、？ で文章を区切り、文章ごとに音声変換処理を実行します)

VOICEVOX ENGINE、VOICEVOX NEMO ENGINE、COEIROINK ENGINEのユーザ辞書に対し、単語の追加、編集、削除、ファイルからの一括登録などができます。

# 動作要件

Rocky Linux 8.8で、Ruby 2.5.9を使用して作成していますが、LinuxでRubyが実行できる環境であれば動くと思います。

VOICEVOX ENGINE、VOICEVOX NEMO ENGINE、COEIROINK ENGINEは別途用意して起動してください。

VOICEVOX ENGINEはDockerを使用して起動するのが簡単だと思います。以下のようなコマンドで起動するとネットワーク経由でVOICEVOX ENGINEにアクセスできるようになります。(意図しないクライアントから接続できないようにファイアウォールなどで制限を行うことをおすすめします)

```bash
# docker run -d --restart=always --network=host --name=voicevox voicevox/voicevox_engine:cpu-ubuntu20.04-0.14.6
```

VOICEVOX NEMO ENGINEは、同様に以下のように起動できます。VOICEVOX ENGINEとは異なるポート番号を使用するため、同時に起動することが可能です。

```bash
# docker run -d --restart=always --network=host --name=voicevox voicevox/voicevox_nemo_engine:cpu-ubuntu20.04-0.14.0
```

COEIROINKはLinux版がありません。Windows版の場合、コマンドプロンプトで以下のように実行することで起動できます。IPアドレスは、Windowsマシンに割り当てたものを指定してください。wineを使用してLinux上でWindows版を起動することもできるようです。

```
C:\COEIROINK-CPU-v.1.6.0> run.exe --host 192.168.0.21
```

# インストール、使用準備

ファイル一式を展開して設置してください。

`etc/config.rb` が設定ファイルです。ファイルを編集し、

```
VOICEVOX_ENGINE = [ "192.168.0.11:50021" ]
```

のように、VOICEVOX ENGINEを起動している IP アドレス or ホスト名と、ポート番号に修正してください。

複数のVOICEVOX ENGINEを使用する場合は、

```
VOICEVOX_ENGINE = [ "192.168.0.11:50021", "192.168.0.12:50021" ]
```

のように、カンマ区切りで複数記述してください。

VOICEVOX ENGINEを使用しない場合は `VOICEVOX_ENGINE = [ ]` と、値を空にしてください。

VOICEVOX NEMO ENGINEを使用する場合は同様に、

```
VOICEVOX_NEMO_ENGINE = [ "192.168.0.21:50121" ]
```

COEIROINKを使用する場合は同様に、

```
COEIROINK_ENGINE = [ "192.168.0.21:50031" ]
```

のように設定してください。VOICEVOX ENGINEと同様にカンマ区切りで複数指定も可能です。COEIROINK を使用しない場合は `COEIROINK_ENGINE = [ ]` と、値を空にしてください。

VOICEVOX、COEIROINK両方の音声を混在させたWAVファイルを出力可能です。VOICEVOXの音声のみで作成したWAVファイルはサンプリングレートが24kHzとなりますが、COEIROINKの音声のみ、またはVOICEVOXとCOEIROINKの音声を混在させて作成したWAVファイルはサンプリングレートが44.1kHzとなります。

設定後に、

```bash
$ vvtts --check
```

コマンドで、設定した VOICEVOX ENGINE、COEIROINK ENGINEが動作しているかどうか確認できます。VOICEVOX ENGINEを複数使用する場合はバージョンを揃えてください。COEIROINK ENGINEを複数使用する場合は、バージョンとインストール済み音声ライブラリを揃えてください。

指定可能なSpeaker IDを確認するには、

```bash
$ vvtts --list
```

と実行することで、VOICEVOX ENGINE、VOICEVOX NEMO ENGINE、COEIROINK ENGINEから情報を取得して表示されます。

アンインストールする場合は、設置したファイルを全て削除してください。

# 使い方

## テキストを音声ファイルに変換

テキストを音声ファイルに変換する

```bash
$ vvtts -s 2 "音声ファイルに変換したいテキストをここに入力してください"
```

VOICEVOX NEMO の音声を指定する場合は、Speaker IDの前に `n` を付けて、`-s n0` のように指定してください。
COEIROINK の音声を指定する場合は、Speaker IDの前に `c` を付けて、`-s c1` のように指定してください。

テキストが記述されたファイルを指定し、音声ファイルに変換する

```bash
$ vvtts -s 3 -f text.txt -1
```

空行で別々のファイルに分割せずに、1 つのファイルに保存したい場合は `-1` オプションも指定してください。

他のコマンドが出力したメッセージを音声ファイルに変換する

```bash
$ date | vvtts
```

その他、使用できるオプション

| オプション                              | 説明                                                                                                         |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| -h                                      | 指定可能なオプションの情報を出力する                                                                         |
| -f <ファイル>                           | テキストを指定したファイルから読み込みます                                                                   |
| -o <出力ファイル名>                     | 出力ファイル名を指定します。拡張子は不要です。指定しない場合は「output」になります。`-o` を指定せず `-f` オプションでファイルを指定した場合は、指定ファイル名から `.txt` を取り除いた文字列が出力ファイル名になります                           |
| -1                                      | 文章全体を 1 つのファイルに出力します。指定しない場合は、空行を区切りとして連番のファイルに出力します        |
| -p                                      | ファイルに出力する代わりに `aplay` コマンドを使用して再生します                                              |
| -s <整数 または、c整数>                               | 音声の種類を Speaker ID で指定します。COEIROINKの音声を指定する場合は `c整数` を指定してください。`r` を指定するとランダムに選択されます                                 |
| -m <整数>,<小数>                        | モーフィングした音声を出力します。モーフィング先の Speaker ID とモーフィングレートをカンマ区切りで指定します |
| -i <秒>                                 | 文章間に挿入する無音時間を指定します。小数での指定が可能です                                             |
| -I <秒>                                 | 文節間に挿入する無音時間を指定します。小数での指定が可能です                                             |
| -q                                      | 画面に何も表示しない                                                                                     |
| -v                                      | 画面に VOICEVOX ENGINE に渡される文字列なども表示します                                                  |
| -c <設定ファイル>                       | `etc/config.rb` 以外の設定ファイルを使用したい場合に指定します                                           |
| -r <置換リストファイル>                   | `etc/replace.list` 以外の置換リストファイルを使用したい場合に指定します                                |
| --first <秒>                            | 最初の無音時間を指定します。小数での指定が可能です                                                       |
| --last <秒>                             | 最後の無音時間を指定します。小数での指定が可能です                                                       |
| --query <数字>                          | 指定した Speaker ID でクエリを実行します                                                                 |
| --stdout                                | 生成した WAV データをファイルではなく、標準出力に出力します                                              |
| --raw                                   | 置換リストやスペース削除などの処理を行いません                                                           |
| --speed <スピードスケール>              | 読み上げ速度を変更したい場合に指定する。デフォルト値は `1.0`                                             |
| --pitch <ピッチスケール>                | ピッチを変更したい場合に指定する。デフォルト値は `0.0`                                                   |
| --intonation <イントネーションスケール> | イントネーションの強さを変更したい場合に指定する。デフォルト値は `1.0`                                   |
| --volume <ボリュームスケール>           | ボリュームを変更したい場合に指定する。デフォルト値は `1.0`                                               |
| --cmudict                               | CMU Pronouncing Dictionary を使用してアルファベットをカナ読みする                                        |
| --check                                 | サーバの状態を確認する                                                                                   |
| --list                                 | 使用可能なSperker IDとキャラクター、スタイルの対応情報を表示する                                          |

## テキストを読み上げ

`aplay -D sysdefault output.wav` コマンドで音声ファイルを再生できる環境であれば、`-p` オプションを付けることで直接読み上げます。

```bash
$ vvtts -p -s 8 "読み上げたいテキストをここに入力してください"
```

`aplay` コマンドで `sysdefault` 以外のデバイスを使用したい場合は、`etc/config.rb` の `APLAY_VVTTS_DEVICE` の設定値を変更してください。

一般ユーザで読み上げたい場合、ユーザが `audio` グループに所属している必要があります。

## テキスト内で音声種別や速度などを変更する

以下のように特定の書式を文章の先頭に記述して、

```
#{s9}こんにちは
#{s10,S1.5}こんにちは
```

変換を実行することで音声種別などのパラメータを途中から変更することができます。

```
$ vvtts -f text.txt
```

同様に以下のように記述可能です。複数のパラメータを変更したい場合は `#{s12,I1.5}` のようにカンマ区切りで記述できます。

| テキストに記述する文字 | 効果                                                                |
| ---------------------- | ------------------------------------------------------------------- |
| #{s12}                 | 音声種別変更。数字の代わりに「R」を記述するとランダムで選択されます。VOICEVOX NEMOの音声を指定する場合は `#{sn0}` のように n を、COEIROINKの音声を指定する場合は `#{sc1}` のように c を付けて指定してください |
| #{q5}                  | クエリ時の声の種別を変更                                            |
| #{m3,r0.5}             | モーフィング先の声の種別と、モーフィングレートを変更                |
| #{S0.8}                | スピードスケールを変更                                              |
| #{P-0.1}               | ピッチスケールを変更                                                |
| #{I1.5}                | イントネーションスケールを変更                                      |
| #{V1.2}                | ボリュームスケールを変更                                            |

数字部分に設定したい値を記述します。数字の代わりに `X` を記述すると、デフォルト値に戻すことができます。

## 置換リスト

`etc/replace.list` が置換リストです。このリストに基づいて入力文字列の置換処理が行われます。

置換リストは、1 行に 1 項目、置換前の文字列と置換後の文字列をタブ区切りで記述してください。`#` で始まる行はコメント行として無視されます。

置換前の文字列は正規表現で記述することができます。

```replace.list
さようなら      ごきげんよう
私|わたし       わたくし
[Pp]ython       パイソン
```

置換リストによる置換だけでなく、全角英数字を半角英数字に変換、スペースを削除などの処理が行われた後、VOICEVOX ENGINE に渡されます。入力した文字列をそのまま VOICEVOX ENGINE に渡したい場合は `--raw` オプションを指定してください。

## 読み方&アクセント辞書

`vvdict` コマンドで、VOICEVOX ENGINE、VOICEVOX NEMO ENGINE、COEIROINK ENGINEに読み方&アクセント辞書を登録できます。複数台のエンジンを設定している場合は、全てのエンジンに対して操作を行います。

単語追加 - `単語` `読み方(カタカナ)` `アクセント核位置` `優先度` を順に指定してください。優先度(1~9 大きいほど優先度高)は省略可で省略すると `5` に設定されます

```
$ vvdict add ruby ルビー 1 4
```

単語修正 - `単語` `読み方(カタカナ)` `アクセント核位置` `優先度` を順に指定してください。優先度(1~9 大きいほど優先度高)は省略可で省略すると `5` に設定されます

```
$ vvdict mod ruby ルビー 0 6
```

単語削除 - `単語` を指定してください

```
$ vvdict del ruby
```

単語をすべて削除

```
$ vvdict deleteall
```

登録済みの単語表示 (この出力をリダイレクトでファイル保存すれば、一括登録リストとして使えます)

```
$ vvdict show
```

単語を一括登録リストからまとめて登録 (一括登録リストは `単語` `読み方(カタカナ)` `アクセント核位置` `優先度` をタブ区切りで 1 行に 1 単語づつ記述。優先度(1~9 大きいほど優先度高)は省略可で省略すると `5` に設定されます)

```
$ vvdict listadd list.txt
```

単語をすべて削除したうえで、一括登録リストからまとめて登録

```
$ vvdict rereg list.txt
```

## CMU Pronoucing Dictionary を使用した英語のカナ読み上げ

`--cmudict` オプションを付けることで [CMU Pronouncing Dictionary](https://github.com/cmusphinx/cmudict) (Copyright (C) 1993-2015 Carnegie Mellon University. All rights reserved.) を使用した英語のカタカナ変換を行うことができます。本機能は [english_to_kana](https://github.com/morikatron/snippet/tree/master/english_to_kana) のサンプルコードを基に Ruby で再実装したうえで少し改良(?)しています。短めの英単語は VOICEVOX の方が自然に読み上げてくれることが多い印象のため、4 文字以上の英単語について本機能が適用されます。

# その他

チャットの読み上げなどで利用できるよう、入力されたテキストを順番に読み上げる簡易ツールを作成しています。`vvtts` コマンドで読み上げを行う場合と同じく、`aplay -D sysdefault <音声ファイル>.wav` で音声を再生できる環境が必要です。

起動

```bash
$ sbin/seqread start
```

起動すると `seqread.rb` が実行されます。`seqread.rb` 実行中は `seqread` コマンドで読み上げ文字列の登録ができます。(`var/run/seqread.sock` に対する書き込み権限が必要なことに注意ください)

読み上げ文字列は、コマンドオプションとして指定するか、パイプで渡します。

```
$ seqread "読み上げたいメッセージ"
$ cat text.txt | seqread
```

登録された文字列は、`vvtts` コマンドを用いて登録された順に音声変換後再生されます。再生中にも並行して音声変換が実行されるようになっています。

チャットボットで使用される[Hubot](https://hubot.github.com/)で `seqread` コマンドを呼び出すためのサンプルスクリプトが `etc/hubot_script/yomiage.js` にあります。

# ライセンス

VOICEVOX_CLI_Client is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).

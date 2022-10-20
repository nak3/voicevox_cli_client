#!/bin/env ruby

## 一般設定

# VOICEVOX ENGINEのホスト名orIPアドレス、ポート番号を指定する配列 (複数設定すると並列で変換を実行。使用しない場合は空配列を設定してください)
VOICEVOX_ENGINE = [ "127.0.0.1:50021" ]

# COEIROINK ENGINEのホスト名orIPアドレス、ポート番号を指定する配列 (複数設定すると並列で変換を実行。使用しない場合は空配列を設定してください)
COEIROINK_ENGINE = [ ]

# HTTPのタイムアウト(秒)
HTTP_TIMEOUT = 300

# 出力ファイル名のデフォルト値
OUTFILENAME = "output"


## 出力される音声に関する設定

# VOICEVOXのSpeakerIDと声の対応
#  0: 四国めたん(あまあま)         10: 雨晴はう(ノーマル)    20: モチノ・キョウコ(ノーマル)  30: No.7(アナウンス)
#  1: ずんだもん(あまあま)         11: 玄野武宏(ノーマル)    21: 剣崎雌雄(ノーマル)          31: No.7(読み聞かせ)
#  2: 四国めたん(ノーマル)         12: 白上虎太郎(ふつう)    22: ずんだもん(ささやき)        32: 白上虎太郎(わーい)
#  3: ずんだもん(ノーマル)         13: 青山龍星(ノーマル)    23: WhiteCUL(ノーマル)          33: 白上虎太郎(びくびく)
#  4: 四国めたん(セクシー)         14: 冥鳴ひまり(ノーマル)  24: WhiteCUL(たのしい)          34: 白上虎太郎(おこ)
#  5: ずんだもん(セクシー)         15: 九州そら(あまあま)    25: Whitecul(かなしい)          35: 白上虎太郎(びえーん)
#  6: 四国めたん(ツンツン)         16: 九州そら(ノーマル)    26: Whitecul(びえーん)
#  7: ずんだもん(ツンツン)         17: 九州そら(セクシー)    27: 後鬼(人間ver.)
#  8: 春日部つむぎ(ノーマル)       18: 九州そら(ツンツン)    28: 後鬼(ぬいぐるみver.)
#  9: 波音リツ(ノーマル)           19: 九州そら(ささやき)    29: No.7(ノーマル)

# COEIROINKのSpeakerIDと声の対応
# c0: つくよみちゃん(れいせい)    c10: アルマちゃん(表-v2)  c50: AI声優-朱花(のーまる)
# c1: MANA(のーまる)              c11: アルマちゃん(裏)     c60: AI声優-青葉(のーまる)
# c2: おふとんP(のーまるv2)       c20: おふとんP(あせり)    c70: AI声優-銀芽(のーまる)
# c3: ディアちゃん(のーまる)      c21: おふとんP(よろこび)
# c4: アルマちゃん(表-v1)         c22: おふとんP(ささやき)
# c5: つくよみちゃん(おしとやか)  c30: KANA(のーまる)
# c6: つくよみちゃん(げんき)      c31: KANA(えんげき)
# c7: MANA(いっしょうけんめい)    c40: MANA(ごきげん)
# c8: おふとんP(ナレーション)     c41: MANA+(ふくれっつら)
# c9: おふとんP(かなしみ)         c42: MANA+(しょんぼり)

# 声の種類のデフォルト値 (SpeakerIDを指定)
SPEAKER = "0"

# 音声種別にランダムが指定されたとき、この配列からSpeakerIDがランダムで選択される(COEIROINKのSpeakerIDは「'c0'」のようにcをつけて記述してください)
RANDOM_SPEAKER = ['0','1','2','3','4','5','6','7','8','8','8','8','9','9','9','9',
                  '10','10','10','10','11','11','11','11','12','13','13','13','13',
                  '14','14','14','14','15','16','17','18','19','20','20','20','20',
                  '21','21','21','21','22','23','24','25','26','27','27','28','28',
                  '29','29','30','31','32','33','34','35',
                  'c0','c0','c1','c2','c3','c3','c3','c3','c4','c4','c5','c6','c7',
                  'c8','c9','c10','c11','c20','c21','c22','c30','c30','c31','c31',
                  'c40','c41','c42','c50','c50','c50','c50','c60','c60','c60','c60',
                  'c70','c70','c70','c70']

# 声ごとのスピード、ピッチ、イントネーション、ボリュームのデフォルト補正値
#  スピード　　　　　：話速にこの値を掛けて補正　　　　　　　0.50～1.50 程度の範囲を推奨
#  ピッチ　　　　　　：ピッチにこの値を足して補正　　　　　 -0.10～0.10 程度の範囲を推奨
#  イントネーション　：イントネーションにこの値を掛けて補正　0.00～2.00 程度の範囲を推奨
#  ボリューム　　　　：音量にこの値を掛けて補正　　　　　　　0.10～2.00 程度の範囲を推奨
VOICEVOX_CORRECT_MATRIX = {
  # ID      スピード      ピッチ  イントネーション  ボリューム
  "0" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  0:四国めたん(あまあま)
  "1" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  1:ずんだもん(あまあま)
  "2" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  2:四国めたん(ノーマル)
  "3" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  3:ずんだもん(ノーマル)
  "4" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  4:四国めたん(セクシー)
  "5" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  5:ずんだもん(セクシー)
  "6" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  6:四国めたん(ツンツン)
  "7" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  7:ずんだもん(ツンツン)
  "8" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  8:春日部つむぎ(ノーマル)
  "9" =>  [  1.00,        0.00,        1.00,        1.00  ],  #  9:波音リツ(ノーマル)
  # ID      スピード      ピッチ  イントネーション  ボリューム
  "10" => [  1.00,        0.00,        1.00,        1.00  ],  # 10:雨晴はう(ノーマル)
  "11" => [  1.00,        0.00,        1.00,        1.00  ],  # 11:玄野武宏(ノーマル)
  "12" => [  1.00,        0.00,        1.00,        1.00  ],  # 12:白上虎太郎(ふつう)
  "13" => [  1.00,        0.00,        1.00,        1.00  ],  # 13:青山龍星(ノーマル)
  "14" => [  1.00,        0.00,        1.00,        1.00  ],  # 14:冥鳴ひまり(ノーマル)
  "15" => [  1.00,        0.00,        1.00,        1.00  ],  # 15:九州そら(あまあま)
  "16" => [  1.00,        0.00,        1.00,        1.00  ],  # 16:九州そら(ノーマル)
  "17" => [  1.00,        0.00,        1.00,        1.00  ],  # 17:九州そら(セクシー)
  "18" => [  1.00,        0.00,        1.00,        1.00  ],  # 18:九州そら(ツンツン)
  "19" => [  1.00,        0.00,        1.00,        1.00  ],  # 19:九州そら(ささやき)
  # ID      スピード      ピッチ  イントネーション  ボリューム
  "20" => [  1.00,        0.00,        1.00,        1.00  ],  # 20:モチノ・キョウコ(ノーマル)
  "21" => [  1.00,        0.00,        1.00,        1.00  ],  # 21:剣崎雌雄(ノーマル)
  "22" => [  1.00,        0.00,        1.00,        1.00  ],  # 22:ずんだもん(ささやき)
  "23" => [  1.00,        0.00,        1.00,        1.00  ],  # 23:WhiteCUL(ノーマル)
  "24" => [  1.00,        0.00,        1.00,        1.00  ],  # 24:WhiteCUL(たのしい)
  "25" => [  1.00,        0.00,        1.00,        1.00  ],  # 25:Whitecul(かなしい)
  "26" => [  1.00,        0.00,        1.00,        1.00  ],  # 26:Whitecul(びえーん)
  "27" => [  1.00,        0.00,        1.00,        1.00  ],  # 27:後鬼(人間ver.)
  "28" => [  1.00,        0.00,        1.00,        1.00  ],  # 28:後鬼(ぬいぐるみver.)
  "29" => [  1.00,        0.00,        1.00,        1.00  ],  # 29:No.7(ノーマル)
  # ID      スピード      ピッチ  イントネーション  ボリューム
  "30" => [  1.00,        0.00,        1.00,        1.00  ],  # 30:No.7(アナウンス)
  "31" => [  1.00,        0.00,        1.00,        1.00  ],  # 31:No.7(読み聞かせ)
  "32" => [  1.00,        0.00,        1.00,        1.00  ],  # 32:白上虎太郎(わーい)
  "33" => [  1.00,        0.00,        1.00,        1.00  ],  # 33:白上虎太郎(びくびく)
  "34" => [  1.00,        0.00,        1.00,        1.00  ],  # 34:白上虎太郎(おこ)
  "35" => [  1.00,        0.00,        1.00,        1.00  ],  # 35:白上虎太郎(びえーん)
}
COEIROINK_CORRECT_MATRIX = {
  # ID      スピード      ピッチ  イントネーション  ボリューム
  "0" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c0: つくよみちゃん(れいせい)
  "1" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c1: MANA(のーまる)
  "2" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c2: おふとんP(のーまるv2)
  "3" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c3: ディアちゃん(のーまる)
  "4" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c4: アルマちゃん(表-v1)
  "5" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c5: つくよみちゃん(おしとやか)
  "6" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c6: つくよみちゃん(げんき)
  "7" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c7: MANA(いっしょうけんめい)
  "8" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c8: おふとんP(ナレーション)
  "9" =>  [  1.00,        0.00,        1.00,        0.60  ],  #  c9: おふとんP(かなしみ)
  # ID     スピード      ピッチ  イントネーション  ボリューム
  "10" => [  1.00,        0.00,        1.00,        0.60  ],  # c10: アルマちゃん(表-v2) 
  "11" => [  1.00,        0.00,        1.00,        0.60  ],  # c11: アルマちゃん(裏)    
  "20" => [  1.00,        0.00,        1.00,        0.60  ],  # c20: おふとんP(あせり)   
  "21" => [  1.00,        0.00,        1.00,        0.60  ],  # c21: おふとんP(よろこび)
  "22" => [  1.00,        0.00,        1.00,        0.60  ],  # c22: おふとんP(ささやき)
  "30" => [  1.00,        0.00,        1.00,        0.60  ],  # c30: KANA(のーまる)
  "31" => [  1.00,        0.00,        1.00,        0.60  ],  # c31: KANA(えんげき)
  "40" => [  1.00,        0.00,        1.00,        0.60  ],  # c40: MANA(ごきげん)
  "41" => [  1.00,        0.00,        1.00,        0.60  ],  # c41: MANA+(ふくれっつら)
  "42" => [  1.00,        0.00,        1.00,        0.60  ],  # c42: MANA+(しょんぼり)
  # ID     スピード      ピッチ  イントネーション  ボリューム
  "50" => [  1.00,        0.00,        1.00,        0.60  ],  # c50: AI声優-朱花(のーまる)
  "60" => [  1.00,        0.00,        1.00,        0.60  ],  # c60: AI声優-青葉(のーまる)
  "70" => [  1.00,        0.00,        1.00,        0.60  ],  # c70: AI声優-銀芽(のーまる)
}

# 最初の無音時間のデフォルト値 (秒)
FIRST_SILENT_TIME = 0.0

# 最後の無音時間のデフォルト値 (秒)
LAST_SILENT_TIME = 0.0

# 文章間で無音にする間隔のデフォルト値 (秒)
INTERVAL = 0.8

# 段落間で無音にする間隔のデフォルト値 (秒)
PARAGRAPH_INTERVAL = 2.0


## 音声再生に関する設定

# 音声再生に使用するコマンド (aplay,sox)
PLAY_CMD = "aplay"

# vvttsコマンドがaplayコマンド実行時に使用するデバイス名 (XRDP_PULSE_* 環境変数がないか、--no-rdp が指定された場合に使用される)
APLAY_VVTTS_DEVICE = "sysdefault"

# seqread.rbがaplayコマンド使用時に使用するデバイス名 (「sysdefault」「plughw:1,0」などを指定する)
APLAY_SEQREAD_DEVICE = "sysdefault"

# vvttsコマンドがsox (playコマンド) 実行時に使用するデバイス名 (XRDP_PULSE_* 環境変数がないか、--no-rdp が指定された場合に使用される)
SOX_VVTTS_DEVICE = "hw:0,0"

# seqread.rbがsox (playコマンド) 実行時に使用するデバイス名
SOX_SEQREAD_DEVICE = "hw:0,0"


## 音声ファイルのmp3化に関する設定

# mp3変換に使用するコマンド (sox,ffmpeg)
CONV_CMD = "sox"

# soxのmp3変換オプション (-C オプションでビットレート (kbps) と品質 (0-9 小さいほど高品質) を指定)
SOX_OPT1 = "-C 128.2"
SOX_OPT2 = "channels 1 rate 44.1k"

# ffmpegのmp3変換オプション
FFMPEG_OPT = "-vn -ar 44100 -b:a 128k -c:a libmp3lame -f mp3 -y"

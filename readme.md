[English](./readme_en.md)
# p-ffmpeg
p-ffmpeg、parallel-ffmpeg(パラレルffmpeg)は複数の音楽ファイルに対して並列でフォーマット変換を行うシェルスクリプトです。

詳細なオプションの設定はできません。

動画フォーマットには対応していません。

変換可能なフォーマットについても制限をかけてあります。対応フォーマットは以下を参照。

## 環境
Ubuntuまたはその他Linux

検証環境はWSL Ubuntu 20.04を使用

## インストール

1. ffmpeg をインストール

	以下はUbuntuの例
	```
	$ sudo apt install ffmpeg
	```
	他のdistroなら自分で調べてください。yum?

2. p-ffmpeg(本スクリプト)をインストール
	1. p-ffmpegをgit cloneなどしインストール、ディレクトリに移動
		```
		$ cd p-ffmpeg
		```

	2. `install.sh` の実行権限の変更
		```
		$ sudo chmod 555 install.sh
		```

	3. `install.sh` を管理者権限で実行
		```
		$ sudo ./install.sh
		```
	
	インストール後はダウンロードしたファイルは削除して構いません。

## 使い方

1. 変換したいファイルがあるディレクトリに移動
	```
	$ cd target_dir
	```

2. p-ffmpeg
	```
	$p-ffmpeg flac m4a export
	```
	これでディレクトリにあるflacファイルがすべてm4aに変換されてexportディレクトリに出力されます。

## 対応フォーマット

ffmpeg自体は素晴らしいソフトなので色々なフォーマットに対応していますが
p-ffmpegにはそこまで複雑な操作を期待していないのでフォーマットを制限しています。対応は以下の通りです。

### 変換元
- wav
- flac
- wav

### 変換先
- mp3
- m4a
- aac
- wma
- wav



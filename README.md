# Information_board

Perl mojolicious を利用した html 等をスライドショーのように表示するプログラム

現在、開発途中の為、動作安定していません。

# 使い方

Mojolicious のインストールされている状況で次を実行

```
./info_board.pl daemon
```

正常に起動すれば Webブラウザで 3000ポートにアクセス

public/ ディレクトリ内の HTML と PDF を探し、順番にブラウザに表示します。

public/ 内に予め入っているデータはサンプルデータなので全て消去して構いません。


## Mojolicious のインストール

cpanmコマンド等を利用しインストール

```
cpanm Mojolicious
```



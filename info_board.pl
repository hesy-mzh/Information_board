#!/usr/bin/env perl
use Mojolicious::Lite -signatures;


get '/' => sub ($c) {
  $c->render(template => 'index');
};


# 現在時刻 出力
get 'now' => sub ($c) {
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
  $mon++;
  $year += 1900;
  $c->render(json => {
      sec=>$sec, min=>$min, hour=>$hour, mday=>$mday, mon=>$mon, year=>$year, wday=>$wday
             });
};

# ファイルリスト 出力
get '/list' => sub($c) {
  # webブラウザから見えるpathを指定
  my $dir = "public/"; # ファイルを配置したディレクトリを指定 末に"/"が必要
  chdir $dir or die "Cannot change working directory $dir: $!";
  my @all_files = glob "*"; # ファイル一覧取得
  chdir "../";
  my @list_ext = ("pdf", "html");  # リストアップする拡張子
  my $file_list = {}; # JSONに変換するためのハッシュ
  # 拡張子毎に分類
  for my $str (@list_ext) {
    my @arr = grep {/\.$str$/i} @all_files;
    $file_list->{$str} = \@arr;
  }
  $c->render(json => $file_list);
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
%= stylesheet begin
  body {
    background:gray;
  }
  #view_area {
    width: 95vw;
    height: 95vh;
    display: block;
    margin: 0 auto;
  }
% end
%= javascript 'https://code.jquery.com/jquery-1.12.4.min.js';
%= javascript begin

$(function(){
    // 時刻取得 一定時間毎にajax通信を実施
    setInterval(function(){
        $.ajax({
            url: '<%= url_for("/now") %>',
            type: 'GET',
            dataType: 'json'
        }).done(function(json){ /* 通信成功時 */
            var week = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sta"];
            $('#now_time').html( // json形式の時刻データを整形し出力
                json.year +"/"+ ("0"+json.mon).slice(-2) +"/"+ ("0"+json.mday).slice(-2)
                    +" ("+ week[json.wday] +") " // 曜日 出力
                    + ("0"+json.hour).slice(-2) +":"+ ("0"+json.min).slice(-2)
                    +":"+ ("0"+json.sec).slice(-2) // 秒数 出力
            );
        }).fail(function(json){ /* 通信失敗時 */
            console.log("Network Error : date time " + json);
        });
    }, 500);

    // iframeの表示
    setInterval(function(){
        $.ajax({
            url: '<%= url_for("/list") %>',
            type: 'GET',
            dataType: 'json'
        }).done(function(json){ /* 通信成功時 */
            console.log("start");
            var arr = json.pdf;
            var array = arr.concat(json.html);
            $.each(array, function(index, element) {
                setTimeout(function(){
                    console.log(index +":"+ element);
                    console.log("waiting now");
                    $('#view_area').attr("src", element); // iframeのsrcを設定
                }, 20000*index);
            });
        }).fail(function(json){ /* 通信失敗時 */
            console.log("Network Error : view file " + json);
        });
    }, 20000);

});

% end
<span id="now_time">Just a minute.</span>
<iframe id="view_area">Wait a moment.</iframe>


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

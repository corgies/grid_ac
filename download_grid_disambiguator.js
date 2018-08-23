var sspage=(new XMLSerializer).serializeToString(document),blob=new Blob([sspage],{type:"text/plain"}),bloburl='https://www.grid.ac/disambiguate?utf8=%E2%9C%93&query_form%5Bquery%5D=College+of+Knowledge+and+Library+Sciences%2C+School+of+Informatics%2C+University+of+Tsukuba&commit=Disambiguate',a=document.createElement("a");a.download=Date.now()+'.html';a.href=bloburl;a.click(); sleep(3000); console.log("College of Knowledge and Library Sciences, School of Informatics, University of Tsukuba");function sleep(time) { const d1 = new Date(); while (true) { const d2 = new Date(); if (d2 - d1 > time) { return; } } }

// # 簡易説明 (※ Google Chrome 環境でしか動作確認をしていない)
// 概要: GRIDの名寄せ機能ページ (https://www.grid.ac/disambiguate) に対して「任意のクエリ (機関名称)」による検索を行ない、検索結果ページを保存するためのブックマークレット (Bookmarklet) 。
// 設定1: sleep(3000); のように任意のwait (待ち時間) を指定する ※ ある程度の件数の検索を行なう必要がある場合のため。
// 設定2: 「query%5D=」と「&commit=Disambiguate」の間に「機関名称をパーセントエンコーディングした文字列」を記述する。例) "College of Knowledge and Library Sciences, School of Informatics, University of Tsukuba" -> "College+of+Knowledge+and+Library+Sciences%2C+School+of+Informatics%2C+University+of+Tsukuba"
// 設定3: console.log() に任意の文字列を入れる (実行時にconsole画面上に表示される文字列なので、必ずしも指定する必要はない)
// 使い方1: ウェブブラウザでGRIDの名寄せ機能ページ (https://www.grid.ac/disambiguate) を開く。このとき、「reCAPTCHA」が表示されることがあるので回答する。
// 使い方2: 検証 > Console を開き、コマンドを入力して実行する。無事に実行できれば、検索結果ページが、実行時の「タイムスタンプ (数値列).html」の名称でHTMLファイルとして保存される。
// 備考1: 「reCAPTCHA」が要求されている状態で使用すると検索結果ページを保存することができないので注意すること。
// 備考2: Web APIが公開/提供されていれば、本来、こんなに面倒なことをする必要は生じないはず。。
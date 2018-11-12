//プログラムで使用する変数の設定
$(function() {
  var button = document.getElementById('word_registration_button');
  var form = document.getElementById('word_form');
  var termArea = document.getElementById('word_term_registration');
  var memoArea = document.getElementById('word_memo_registration');

  var maxTermNum = termArea.getAttribute('maxlength');
  var maxMemoNum = memoArea.getAttribute('maxlength');

// 残り文字を表示する要素の追加
  var termMsg = document.createElement('div');
  var termParent = termArea.parentElement;

  var memoMsg = document.createElement('div');
  var memoParent = memoArea.parentElement;

// イベントの指定（テキストエリアでキーをタイプした時残り文字数を変化させる）
  termArea.addEventListener('keyup', function() {
    var currentTermNum = termArea.value.length;
    termParent.insertBefore(termMsg, null);
    termMsg.innerHTML = '残り入力可能字数：' + (maxTermNum - currentTermNum);

    if (currentTermNum <= 49) {
      termMsg.style.color = "#000";
    } else {
      termMsg.style.color = "red";
    }
  });

  memoArea.addEventListener('keyup', function() {
    var currentMemoNum = memoArea.value.length
    memoParent.insertBefore(memoMsg, null);
    memoMsg.innerHTML = '<p>残り入力可能文字数：' + (maxMemoNum - currentMemoNum) + '</p>';

    if (currentMemoNum <= 299) {
      memoMsg.style.color = "#000";
    } else {
      memoMsg.style.color = "red";
    }
  });
});

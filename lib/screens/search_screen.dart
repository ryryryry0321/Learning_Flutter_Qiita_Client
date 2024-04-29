import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // httpという変数を通して、httpパッケージにアクセス
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:study_app_1/models/article.dart';
import 'package:study_app_1/widgets/article_container.dart';
// 相対パス・絶対パスどっちでも指定できる。
import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 検索結果の定義
  List<Article> articles = [];

  // 読み込み時の設定
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qiita Search'),
      ),
      body: Column(
        children: [
          // 検索ボックス
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: TextStyle(
                // ← TextStyleを渡す
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(hintText: "検索ワードを入力してください。"),
              // 入力値送信時イベントの設定ここで、さっきの検索メソッドを呼び出す
              onSubmitted: (String value) async {
                final result = await searchQiita(value);
                setState(() => articles = result);
              },
            ),
          ),
          Expanded(
            child: articles.isNotEmpty
                ? ListView(
                    children: articles
                        .map((article) => ArticleContainer(article: article))
                        .toList(),
                  )
                : Text('記事がひとつもありませんでしたよ', // TODO 最初はからにしたいかも
                    style: TextStyle(
                      // ← TextStyleを渡す
                      fontSize: 18,
                      color: Colors.black,
                    )),
          ),
        ],
      ),
    );
  }

  // 必要に応じてこういう関数もクラス分けしたほうがいいかも
  Future<List<Article>> searchQiita(String keyword) async {
    // 1. http通信に必要なデータを準備をする
    //   - URL、クエリパラメータの設定
    final uri = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '10', // 件数
    });
    //   - アクセストークンの取得 ?? をつけることで、ENVからの読み込みに失敗した場合は空白が変える
    final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

    // 2. Qiita APIにリクエストを送る
    final http.Response res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    // 3. 戻り値をArticleクラスの配列に変換
    // 4. 変換したArticleクラスの配列を返す(returnする)
    if (res.statusCode == 200) {
      // レスポンスをモデルクラスへ変換
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((dynamic json) => Article.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}

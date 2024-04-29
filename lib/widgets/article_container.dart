import 'package:flutter/material.dart';

import '../models/article.dart';
import 'package:intl/intl.dart';

import '../screens/article_screen.dart';

class ArticleContainer extends StatelessWidget {
  // super.key
  const ArticleContainer({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: GestureDetector(
        // GestureDetectorでContainerを囲う
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => ArticleScreen(article: article)),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            // ← 内側の余白を指定
            horizontal: 20,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF55C500), // ← 背景色を指定
            borderRadius: BorderRadius.all(
              // ← 角丸を設定
              Radius.circular(32),
            ),
          ),
          child: Column(
            // 水平方向のどこに寄せるかを指定します。
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 投稿日
              Text(
                DateFormat('yyyy/MM/dd').format(article.createdAt),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              // タイトル
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // タグ
              Text(
                '#${article.tags.join(' #')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Rowの幅いっぱいを使いつつ、子要素の間には等間隔のスペースを配置してくれます。
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ハートアイコンといいね数
                    Column(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                        Text(
                          article.likesCount.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // 投稿者のアイコンと投稿者名
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage:
                              NetworkImage(article.user.profileImageUrl),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.user.id,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}

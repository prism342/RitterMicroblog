import 'package:flutter/material.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_images.dart';
import 'package:ritter_microblog/widgets/my_post_views.dart';

class MyCommentTextField extends StatefulWidget {
  final String postID;
  const MyCommentTextField({super.key, required this.postID});

  @override
  State<MyCommentTextField> createState() => _MyCommentTextFieldState();
}

class _MyCommentTextFieldState extends State<MyCommentTextField> {
  final controller = TextEditingController();

  void onSendButtonPressed() async {
    if (controller.text != "") {
      await createComment(widget.postID, controller.text);
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: theme.colorScheme.surface,
      child: TextField(
          controller: controller,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            // icon: Icon(Icons.person),
            suffixIcon: GestureDetector(
              onTap: onSendButtonPressed,
              child: Icon(
                Icons.send,
                size: 22,
                color: theme.colorScheme.primary,
              ),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            hintText: "Comment...",
            hintStyle: theme.textTheme.labelMedium,
            isDense: true,
          )),
    );
  }
}

class MyCommentCard extends StatelessWidget {
  final CommentActivity? comment;

  const MyCommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (comment == null) {
      return Container();
    } else {
      return Column(
        children: [
          const Divider(height: 0),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            color: theme.colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyProfileWidget(
                    userID: comment!.creatorID, size: WidgetSize.small),
                const SizedBox(height: 12),
                Text(
                  comment!.comment,
                  style: theme.textTheme.bodyMedium,
                ),
                // const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class MyPostDetailScreen extends StatefulWidget {
  final PostActivity post;

  const MyPostDetailScreen({super.key, required this.post});

  @override
  State<MyPostDetailScreen> createState() => _MyPostDetailScreenState();
}

class _MyPostDetailScreenState extends State<MyPostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyPostCard(
              post: widget.post,
              disableNavigation: true,
            ),
            const SizedBox(height: 12),
            Text("Comments", style: theme.textTheme.bodyMedium),
            MyCommentTextField(
              postID: widget.post.docID ?? "",
            ),
            StreamBuilder(
              stream: getPostCommentsStream(widget.post.docID ?? ""),
              builder: (context, snapshot) => Column(
                children: snapshot.data
                        ?.map((comment) => MyCommentCard(comment: comment))
                        .toList() ??
                    [],
              ),
            )
          ],
        ),
      ),
    );
  }
}

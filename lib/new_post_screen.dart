import 'package:flutter/material.dart';

class MyNewPostScreen extends StatefulWidget {
  const MyNewPostScreen({super.key});

  @override
  State<MyNewPostScreen> createState() => _MyNewPostScreenState();
}

class _MyNewPostScreenState extends State<MyNewPostScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "New Post",
            textAlign: TextAlign.center,
          ),
          // backgroundColor: Colors.white,
          // foregroundColor: Colors.pink[400],
          elevation: 2,
        ),
        body: Container(
          // color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Profile pic",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "Username",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                minLines: 3,
                maxLines: 5,
                maxLength: 500,

                style: TextStyle(fontSize: 22), //color: Colors.pink[400]
                strutStyle: StrutStyle(),
                // cursorColor: Colors.pink[400],
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                      // borderSide: BorderSide(color: Colors.pink[400]!)
                      ),

                  labelText: "What's happening...",
                  // fillColor: Colors.pink[400],
                  labelStyle: TextStyle(color: theme.colorScheme.secondary),
                  // focusColor: Colors.pink[400],
                ),
                // cursorColor: Colors.pink[400],
              ),
            ),
            // Text("some text"),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.image_rounded,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                // IconButton(
                //     color: Colors.pink[400],
                //     padding: const EdgeInsets.symmetric(horizontal: 0),
                //     constraints: BoxConstraints(),
                //     // style: ButtonStyle(
                //     //   backgroundColor:
                //     //       MaterialStateProperty.all(Colors.pink[400]),
                //     //   foregroundColor:
                //     //       MaterialStateProperty.all(Colors.pink[400]),
                //     // ),
                //     onPressed: () {},
                //     icon: Icon(
                //       Icons.image_rounded,
                //       // color: Colors.pink[400],
                //     )),
                // IconButton(
                //     onPressed: () {}, icon: Icon(Icons.location_on_rounded)),
                Text("some text"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        // backgroundColor:
                        // MaterialStateProperty.all(Colors.pink[400]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    child: Text(
                      "Post",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

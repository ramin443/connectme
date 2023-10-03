import 'package:connectme/providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/font_constants.dart';
class Profile extends ConsumerWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    double screenwidth=MediaQuery.sizeOf(context).width;
    final profileNotifierState= ref.watch(profileChangeNotifier);
    return Container(
        width: screenwidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            AppBar(
              centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              elevation: 0,
                title: Container(
                  child: Text("Profile",style: TextStyle(
                    fontFamily: intermedium,
                    color: Colors.black87,
                    fontSize: screenwidth * 0.0413,
                  ),),
                ),
            ),
            profileNotifierState.topRow(context, ref),
          ],
        )
    );
  }
}

import 'package:connectme/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/font_constants.dart';
import '../constants/image_constants.dart';
import '../providers/all_providers.dart';

class ProfileNotifier extends ChangeNotifier {
  Widget topRow(BuildContext context, WidgetRef ref) {
    final userChangeNotifierState = ref.watch(userChangeNotifier);
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenwidth,
      padding: EdgeInsets.only(
          left: screenwidth * 0.0818, right: screenwidth * 0.0818),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                userChangeNotifierState.retrieveduserdata.isNotEmpty
                    ? getavatarfromInt(userChangeNotifierState
                        .retrieveduserdata[0].avatarIndex)
                    : appavatar0,
                width: screenwidth * 0.163,
              ),
              Container(
                margin: EdgeInsets.only(left: screenwidth * 0.04),
                //   margin:EdgeInsets.only(bottom: -8),
                //     margin: EdgeInsets.only(top: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontFamily: intermedium,
                              color: Colors.black87,
                              fontSize: screenwidth * 0.0413,
                            ),
                            children: [
                          TextSpan(
                            text: userChangeNotifierState
                                    .retrieveduserdata.isNotEmpty
                                ? userChangeNotifierState
                                    .retrieveduserdata[0].name
                                : "Julia",
                            style: TextStyle(
                              fontFamily: intermedium,
                              color: Colors.black87,
                              fontSize: screenwidth * 0.0413,
                            ),
                          ),
                        ])),
                    RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            style: TextStyle(
                              fontFamily: tiemposfineregularitalic,
                              color: Colors.black87,
                              fontSize: screenwidth * 0.0313,
                            ),
                            children: [
                              TextSpan(
                                text: userChangeNotifierState
                                        .retrieveduserdata.isNotEmpty
                                    ? "@${userChangeNotifierState.retrieveduserdata[0].username}"
                                    : "@julia4512",
                                style: TextStyle(
                                  fontFamily: interregular,
                                  color: Colors.black87,
                                  fontSize: screenwidth * 0.0313,
                                ),
                              ),
                            ])),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: screenwidth * 0.02),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: tiemposfineregularitalic,
                      color: Colors.black87,
                      fontSize: screenwidth * 0.0313,
                    ),
                    children: [
                  TextSpan(
                    text: "Bio",
                    style: TextStyle(
                      fontFamily: intermedium,
                      color: appdarkgrey2,
                      fontSize: screenwidth * 0.0353,
                    ),
                  ),
                ])),
          ),
          Container(
            margin: EdgeInsets.only(top: screenwidth * 0.01),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: tiemposfineregularitalic,
                      color: Colors.black87,
                      fontSize: screenwidth * 0.0313,
                    ),
                    children: [
                  TextSpan(
                    text: userChangeNotifierState.retrieveduserdata.isNotEmpty
                        ? userChangeNotifierState.retrieveduserdata[0].bio
                        : "This is your bio",
                    style: TextStyle(
                      fontFamily: interregular,
                      color: appdarkgrey2,
                      fontSize: screenwidth * 0.0313,
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }

  String getavatarfromInt(int avatarindex) {
    switch (avatarindex) {
      case 0:
        return appavatar0;
      case 1:
        return appavatar1;
      case 2:
        return appavatar2;
      case 3:
        return appavatar3;
      case 4:
        return appavatar4;
      case 5:
        return appavatar5;
      case 6:
        return appavatar6;
      case 7:
        return appavatar7;
      default:
        return appavatar0;
    }
  }
}

import 'dart:ui';

import 'package:connectme/constants/color_constants.dart';
import 'package:connectme/constants/font_constants.dart';
import 'package:connectme/providers/all_providers.dart';
import 'package:connectme/screens/base/home.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Base extends ConsumerWidget {
  Base({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final viewChangeNotifierState= ref.watch(viewChangeNotifier);
    final userChangeNotifierState= ref.watch(userChangeNotifier);
    //  final selectedPageIndex = watch(selectedPageIndexProvider);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: viewChangeNotifierState.selectedbottomindex!=0?
          SizedBox(height: 0,):
        viewChangeNotifierState.createnewPostButton(context),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white30,
        onTap: (index) {
          viewChangeNotifierState.updatebottomindex(index);
          userChangeNotifierState.updateAllUsersList();
          viewChangeNotifierState.updateAllPostsList();
          //     print(screenwidth.toStringAsFixed(1));
          //basecontroller.setindex(index);
        },
        iconSize: screenwidth * 0.0583,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: viewChangeNotifierState.selectedbottomindex,
        items: [
          BottomNavigationBarItem(
              label: "",
              backgroundColor: Colors.transparent,
              icon: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Icon(
                      FeatherIcons.home,
                      size: screenwidth * 0.0589,
                      color: viewChangeNotifierState.selectedbottomindex == 0 ? Color(0xff404040) : Color(0xff8E8E93),
                    ),
                    /*
                                      SvgPicture.asset(basecontroller.selectedindex==0?
                                      homeiconsvg:homeunselectedsvg,width: screenwidth*0.0589,

                                      )*/
                  ],
                ),
              )),
          BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              label: "",
              icon: Container(
                child: Column(
                  children: [
                    Icon(
                      FeatherIcons.user,
                      size: screenwidth * 0.0589,
                      color: viewChangeNotifierState.selectedbottomindex == 1 ? Color(0xff404040) : Color(0xff8E8E93),
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: viewChangeNotifierState.pages[viewChangeNotifierState.selectedbottomindex]

    );
  }
}

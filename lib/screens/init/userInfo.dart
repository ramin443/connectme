import 'package:connectme/constants/color_constants.dart';
import 'package:connectme/constants/image_constants.dart';
import 'package:connectme/datamodels/textPost_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/font_constants.dart';
import '../../providers/all_providers.dart';

class UserInfo extends ConsumerWidget {
   UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    final userChangeNotifierstate= ref.watch(userChangeNotifier);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:userChangeNotifierstate.floatingDoneButton(context,ref),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: screenwidth,
          padding: EdgeInsets.only(
            left: screenwidth * 0.046,
            right: screenwidth * 0.046,
            bottom: screenwidth * 0.28,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: screenwidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
//                          navigateandremovestack(context, basepageRoute);
                        },
                        child: Container(
                       //   margin: EdgeInsets.only(right: screenwidth * 0.032),
                          child: Text(
                            "Skip",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: gilroymediumd,
                              height: 1,
                              color: appdarkgrey2,
                              fontSize: screenwidth * 0.039,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              userChangeNotifierstate.enterdetailspart(context),
              SizedBox(height: screenwidth*0.06,),
              userChangeNotifierstate.selectavatar(context),
            ],
          ),
        ),
      ),
    );
  }

}

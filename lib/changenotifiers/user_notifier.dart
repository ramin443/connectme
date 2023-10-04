import 'dart:math';
import 'package:connectme/datamodels/user_model.dart';
import 'package:connectme/providers/all_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/color_constants.dart';
import '../constants/font_constants.dart';
import '../constants/image_constants.dart';
import '../constants/route_constants.dart';
import '../dbhelpers/user_helpers.dart';

class UserChangeNotifier extends ChangeNotifier {
  TextEditingController fullnametextController = TextEditingController();
  TextEditingController userbiotextController = TextEditingController();
  int selectedavatarindex = 0;
  List<User> retrieveduserdata = [];

  void updateavatarIndex(int index) {
    selectedavatarindex = index;
    notifyListeners();
  }

  int fourRandomDigits() {
    final random = Random();

    // Generate a random integer with 4 digits (between 1000 and 9999)
    int random4DigitNumber = 1000 + random.nextInt(9000);
    return random4DigitNumber;
  }

  void insertusertoDatabase(BuildContext context) async {
    String fullname = fullnametextController.text;
    String bio = userbiotextController.text;
    String username = "${fullname.toLowerCase()}${fourRandomDigits()}";
    User user = User(
        name: fullname,
        bio: bio,
        avatarIndex: selectedavatarindex,
        username: username);
    final dbHelper = UserDatabaseHelper();
    await dbHelper.initDatabase();
    await dbHelper.insertUser(user);
    updateAllUsersList();
    navigtatetonextpage(context);
  }

  void updateAllUsersList() async {
    final dbHelper = UserDatabaseHelper();
    await dbHelper.initDatabase();
    retrieveduserdata = await dbHelper.getAllUsers();
    // print(retrievedtextposts);
    notifyListeners();
  }

  void navigtatetonextpage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, baseroute, (route) => false);
  }

  Widget floatingDoneButton(BuildContext context, WidgetRef ref) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    final userNotifierState = ref.watch(userChangeNotifier);
    final viewNotifierState = ref.watch(viewChangeNotifier);
    return GestureDetector(
      onTap: () {
        if (fullnametextController.text.isNotEmpty) {
          insertusertoDatabase(context);
          viewNotifierState.updateAllPostsList();
          userNotifierState.updateAllUsersList();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: screenwidth * 0.0585,
        ),
        width: screenwidth * 0.785,
        height: screenwidth * 0.131,
        decoration: BoxDecoration(
          color: fullnametextController.text.isEmpty
              ? appmainskyblue.withOpacity(0.55)
              : appmainskyblue,
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Colors.transparent,
                  size: screenwidth * 0.048,
                )),
            Container(
              child: Text(
                "Done",
                style: TextStyle(
                    fontFamily: gilroymediumd,
                    color: Colors.white,
                    fontSize: screenwidth * 0.0426),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Colors.white,
                  size: screenwidth * 0.048,
                ))
          ],
        ),
      ),
    );
  }

  Widget enterdetailspart(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //   margin:EdgeInsets.only(bottom: -8),
            //     margin: EdgeInsets.only(top: 3),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: tiemposfineregular,
                      color: appdarkgrey1,
                      fontSize: screenwidth * 0.064,
                    ),
                    children: [
                  TextSpan(text: "Please enter your"),
                  TextSpan(
                    text: " first name",
                    style: TextStyle(
                      fontFamily: tiemposfineregular,
                      color: appmainskyblue,
                      fontSize: screenwidth * 0.064,
                    ),
                  ),
                ])),
          ),
          Container(
            width: screenwidth * 0.9,
            child: TextFormField(
              onChanged: (v) {
                notifyListeners();
              },
              style: TextStyle(
                  letterSpacing: -0.1,
                  color: Color(0xff4C4C4F),
                  fontFamily: gilroysemibold,
                  fontSize: screenwidth * 0.096),
              cursorColor: applightgrey2,
              keyboardType: TextInputType.name,
              controller: fullnametextController,
              textInputAction: TextInputAction.done,
              maxLength: 9,
              decoration: InputDecoration(
                border: InputBorder.none,
//                      contentPadding: EdgeInsets.only(top: 17),
                hintText: "Robert",
                hintStyle: TextStyle(
                    letterSpacing: -0.1,
                    color: Colors.black.withOpacity(0.2),
                    fontFamily: gilroymediumd,
                    fontSize: screenwidth * 0.108),
              ),
            ),
          ),
          Container(
            //   margin:EdgeInsets.only(bottom: -8),
            //     margin: EdgeInsets.only(top: 3),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: tiemposfineregular,
                      color: appdarkgrey1,
                      fontSize: screenwidth * 0.064,
                    ),
                    children: [
                  TextSpan(
                    text: "Bio",
                    style: TextStyle(
                      fontFamily: tiemposfineregular,
                      color: appmainskyblue,
                      fontSize: screenwidth * 0.064,
                    ),
                  ),
                ])),
          ),
          Container(
            width: screenwidth * 0.9,
            child: TextFormField(
              style: TextStyle(
                  height: 1.2,
                  color: Color(0xff4C4C4F),
                  fontFamily: gilroysemibold,
                  fontSize: screenwidth * 0.038),
              cursorColor: applightgrey2,
              maxLines: 3,
              keyboardType: TextInputType.name,
              controller: userbiotextController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
//                      contentPadding: EdgeInsets.only(top: 17),
                hintText:
                    "Please enter your interests, hobbies, and likes here "
                    "so others can know more about you.",
                hintStyle: TextStyle(
                    height: 1.2,
                    color: Colors.black.withOpacity(0.38),
                    fontFamily: gilroymediumd,
                    fontSize: screenwidth * 0.038),
              ),
            ),
          ),
          Container(
            //   margin:EdgeInsets.only(bottom: -8),
            //     margin: EdgeInsets.only(top: 3),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: tiemposfineregular,
                      color: appdarkgrey1,
                      fontSize: screenwidth * 0.064,
                    ),
                    children: [
                  TextSpan(
                    text: "Select an",
                    style: TextStyle(
                      fontFamily: tiemposfineregularitalic,
                      color: appdarkgrey1,
                      fontSize: screenwidth * 0.064,
                    ),
                  ),
                  TextSpan(
                    text: " avatar ",
                    style: TextStyle(
                      fontFamily: tiemposfineregularitalic,
                      color: appmainskyblue,
                      fontSize: screenwidth * 0.064,
                    ),
                  ),
                  TextSpan(
                    text: "of your choice",
                    style: TextStyle(
                      fontFamily: tiemposfineregularitalic,
                      color: appdarkgrey1,
                      fontSize: screenwidth * 0.064,
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }

  String getAvatarfromIndex(int index) {
    switch (index) {
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

  ScrollController scrollController = ScrollController();

  Widget selectavatar(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  height: screenwidth * 0.66,
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        mainAxisSpacing: 0.0, // Spacing between rows
                        crossAxisSpacing: 0.0, // Spacing between columns
                      ),
                      itemCount: connectmeappavatars.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.only(left: screenwidth * 0.03),
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print("Avatar index here is: $index");
                                      updateavatarIndex(index);
                                      //   setselectedavatarindex(index);
                                    },
                                    child: ClipOval(
                                      child: Image.asset(
                                          connectmeappavatars[index],
                                          width: screenwidth * 0.298,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  selectedavatarindex != index
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : Icon(
                                          CupertinoIcons
                                              .checkmark_alt_circle_fill,
                                          color: appmainskyblue,
                                          size: screenwidth * 0.0693,
                                        )
                                ],
                              )),
                        );
                        /*  ListView.builder(
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return avatarcolumn(context,index);
                    }),*/
                      })),

              Positioned(
                right: 0,
                child: Container(
                  height: screenwidth * 0.66,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icon(
                            CupertinoIcons.chevron_forward,
                            color: Colors.black45,
                            size: 24,
                          )),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
//              scrollController.position.pixels<=5?SizedBox(height: 0,):
              Positioned(
                left: 0,
                child: Container(
                  height: screenwidth * 0.66,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            scrollController.animateTo(
                              scrollController.position.minScrollExtent,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icon(
                            CupertinoIcons.chevron_back,
                            color: Colors.black45,
                            size: 24,
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

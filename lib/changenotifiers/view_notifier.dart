import 'package:connectme/dbhelpers/post_helpers.dart';
import 'package:connectme/screens/base/home.dart';
import 'package:connectme/screens/base/profile.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import '../constants/color_constants.dart';
import '../constants/font_constants.dart';
import '../constants/image_constants.dart';
import '../constants/samplePosts_constants.dart';
import '../datamodels/textPost_Model.dart';
import '../providers/all_providers.dart';

class ViewChangeNotifier extends ChangeNotifier {
  int selectedbottomindex = 0;
  List<Widget> pages = [Home(), Profile()];
  int selectedTabIndex = 0;
  List<String> alltabs = ["All Posts", "Following", "Close Friends", "Explore"];
  bool postsuccesful = false;

  void setshowPostSuccessTrue() {
    postsuccesful = true;
    Future.delayed(Duration(seconds: 4), setshowPostSuccessFalse);
    notifyListeners();
  }

  void setshowPostSuccessFalse() {
    postsuccesful = false;
    notifyListeners();
  }

  TextEditingController newposttextController = TextEditingController();
  FocusNode newpostKeyboardFocusNode = FocusNode();
  bool isAddingNewPost = false;
  String keyboardText = "";
  List<TextPost> retrievedtextposts = [];

  void updatekeyboardtext(String text) {
    keyboardText = text;
    notifyListeners();
  }

  void setaddingNewPostTrue() {
    isAddingNewPost = true;
    notifyListeners();
  }

  void setaddingNewPostFalse() {
    isAddingNewPost = false;
    newposttextController.clear();
    notifyListeners();
  }

  void updatebottomindex(int index) {
    selectedbottomindex = index;
    notifyListeners();
  }

  void updateTabindex(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  void oncreatePostTapped(BuildContext context, TextPost textPost) {
    if (isAddingNewPost) {
      setaddingNewPostFalse();
      disposeOnNewPostTextField();
    } else {
      setaddingNewPostTrue();
      focusOnNewPostTextField(context);
    }
  }

  void updateAllPostsList() async {
    final dbHelper = DatabaseHelper();
    retrievedtextposts = await dbHelper.getAllTextPosts();
    // print(retrievedtextposts);
    notifyListeners();
  }

  void oncreatePostCancelled() {}

  Widget newpostRow(BuildContext context, WidgetRef ref) {
    return isAddingNewPost ? newpost(context, ref) : SizedBox(height: 0);
  }

  Widget postAddedIndicator(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return postsuccesful
        ? Container(
            width: screenwidth * 0.934,
            height: screenwidth * 0.2,
            //  margin: EdgeInsets.only(bottom: screenwidth*0.04),
            padding: EdgeInsets.symmetric(
              horizontal: screenwidth * 0.02,
              vertical: screenwidth * 0.02,
            ),
            decoration: BoxDecoration(
              color: appmainskyblue,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setshowPostSuccessFalse();
                        },
                        child: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Colors.white,
                          size: 18,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_alt_circle_fill,
                      color: Colors.white,
                      size: screenwidth * 0.048,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.017),
                      child: Text(
                        "Post Added Succesfully",
                        style: TextStyle(
                          letterSpacing: -0.1,
                          fontFamily: interregular,
                          color: Colors.white,
                          fontSize: screenwidth * 0.038,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget pageTabs(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenwidth,
      height: screenwidth * 0.112,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: alltabs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                updateTabindex(index);
              },
              child: AnimatedContainer(
                margin: EdgeInsets.only(
                    left: 0 == index ? screenwidth * 0.0468 : 0,
                    right: (alltabs.length - 1) == index
                        ? screenwidth * 0.0468
                        : 0),
                padding: EdgeInsets.symmetric(
                    vertical: screenwidth * 0.032,
                    horizontal: screenwidth * 0.085),
                decoration: BoxDecoration(
                    color: selectedTabIndex == index
                        ? appmainskyblue
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                duration: Duration(milliseconds: 200),
                child: Container(
                  child: Text(
                    alltabs[index],
                    style: TextStyle(
                      fontFamily: gilroymediumd,
                      color: selectedTabIndex == index
                          ? Colors.white
                          : applightgrey1,
                      fontSize: screenwidth * 0.041,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget getPostsBasedonTab(BuildContext context, WidgetRef ref) {
    switch (selectedTabIndex) {
      case 0:
        return allpostlist(context, ref);
      case 1:
        return followingpostslist(context, ref);
      case 2:
        return closeFriendspostslist(context, ref);
      case 3:
        return explorePostslist(context, ref);
      default:
        return explorePostslist(context, ref);
    }
  }

  Widget allpostlist(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (int i = 0; i < alltextposts.length; i++)
          individualpost(context, ref, alltextposts[i])
      ],
    );
  }

  Widget followingpostslist(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (int i = 0; i < allfollowingposts.length; i++)
          individualpost(context, ref, allfollowingposts[i])
      ],
    );
  }

  Widget closeFriendspostslist(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (int i = 0; i < allclosefriendsposts.length; i++)
          individualpost(context, ref, allclosefriendsposts[i])
      ],
    );
  }

  Widget explorePostslist(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (int i = 0; i < allexploreposts.length; i++)
          individualpost(context, ref, allexploreposts[i])
      ],
    );
  }

  void inserttexttoDatabase(TextPost textPost) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.initDatabase();
    await dbHelper.insertTextPost(textPost);
  }

  void deleteDatafromDatabase(TextPost textPost) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.initDatabase();
    dbHelper.deleteData(textPost);
    updateAllPostsList();
  }

  Widget individualpost(
      BuildContext context, WidgetRef ref, TextPost textPost) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    final userNotifierState = ref.watch(userChangeNotifier);
    return Container(
      width: screenwidth * 0.934,
      margin: EdgeInsets.only(
          bottom: screenwidth * 0.0432,
          left: screenwidth * 0.0279,
          right: screenwidth * 0.0279),
      padding: EdgeInsets.only(
          top: screenwidth * 0.0279,
          bottom: screenwidth * 0.0279,
          left: screenwidth * 0.0279,
          right: screenwidth * 0.0279),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xffF1F1F1), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //  height: screenwidth*0.153,
                    //  width: screenwidth*0.153,
                    child: Image.asset(
                      getavatarfromInt(textPost.userAvatar),
                      width: screenwidth * 0.101,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.02),
                    child: Text(
                      textPost.userFullName,
                      style: TextStyle(
                        fontFamily: intersemibold,
                        color: appdarkgrey1,
                        fontSize: screenwidth * 0.0356,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: screenwidth * 0.02, right: screenwidth * 0.02),
                    child: Text(
                      "@${textPost.username}",
                      style: TextStyle(
                        fontFamily: intermedium,
                        color: applightgrey1,
                        fontSize: screenwidth * 0.0305,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: 3,
                    decoration: BoxDecoration(
                        color: applightgrey1, shape: BoxShape.circle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.02),
                    child: Text(
                      textPost.datetime,
                      style: TextStyle(
                        fontFamily: interregular,
                        color: applightgrey1,
                        fontSize: screenwidth * 0.0305,
                      ),
                    ),
                  ),
                ],
              ),
              userNotifierState.retrieveduserdata.isNotEmpty
                  ? textPost.username ==
                          userNotifierState.retrieveduserdata[0].username
                      ? GestureDetector(
                          onTap: () {
                            deleteDatafromDatabase(textPost);
                          },
                          child: Icon(
                            FeatherIcons.delete,
                            color: Colors.redAccent,
                            size: 18,
                          ))
                      : SizedBox(
                          height: 0,
                        )
                  : SizedBox(
                      height: 0,
                    )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: screenwidth * 0.02),
            child: Text(
              textPost.postText,
              maxLines: 12,
              textAlign: TextAlign.left,
              style: TextStyle(
                letterSpacing: -0.1,
                fontFamily: interregular,
                color: Colors.black87,
                fontSize: screenwidth * 0.038,
              ),
            ),
          ),
          SizedBox(
            height: screenwidth * 0.0377,
          ),
          Container(
            width: screenwidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: screenwidth*0.001,),
                Container(
                  margin: EdgeInsets.only(left: screenwidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        FeatherIcons.heart,
                        color: applightgrey1,
                        size: screenwidth * 0.028,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: screenwidth * 0.017),
                        child: Text(
                          textPost.likeCount.toString(),
                          style: TextStyle(
                            letterSpacing: -0.1,
                            fontFamily: interregular,
                            color: applightgrey1,
                            fontSize: screenwidth * 0.028,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FeatherIcons.messageCircle,
                      color: applightgrey1,
                      size: screenwidth * 0.028,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.017),
                      child: Text(
                        textPost.commentCount.toString(),
                        style: TextStyle(
                          letterSpacing: -0.1,
                          fontFamily: interregular,
                          color: applightgrey1,
                          fontSize: screenwidth * 0.028,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FeatherIcons.send,
                      color: applightgrey1,
                      size: screenwidth * 0.028,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.017),
                      child: Text(
                        textPost.shareCount.toString(),
                        style: TextStyle(
                          letterSpacing: -0.1,
                          fontFamily: interregular,
                          color: applightgrey1,
                          fontSize: screenwidth * 0.028,
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    shareTextPost(context, textPost.postText, screenwidth);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenwidth * 0.04,
                        vertical: screenwidth * 0.02),
                    margin: EdgeInsets.only(right: screenwidth * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FeatherIcons.upload,
                          color: Colors.white,
                          size: screenwidth * 0.032,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenwidth * 0.017),
                          child: Text(
                            "Share",
                            style: TextStyle(
                              letterSpacing: -0.1,
                              fontFamily: interregular,
                              color: Colors.white,
                              fontSize: screenwidth * 0.032,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget newpost(BuildContext context, WidgetRef ref) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    final userChangeNotifierState = ref.watch(userChangeNotifier);
    String name = userChangeNotifierState.retrieveduserdata.isNotEmpty
        ? userChangeNotifierState.retrieveduserdata[0].name
        : "Julian";
    String username = userChangeNotifierState.retrieveduserdata.isNotEmpty
        ? userChangeNotifierState.retrieveduserdata[0].username
        : "julian4528";
    int avatarindex = userChangeNotifierState.retrieveduserdata.isNotEmpty
        ? userChangeNotifierState.retrieveduserdata[0].avatarIndex
        : 0;
    String currentdateTime = DateFormat.yMd().add_jm().format(DateTime.now());
    return Container(
      width: screenwidth * 0.934,
      margin: EdgeInsets.only(bottom: screenwidth * 0.0432),
      padding: EdgeInsets.only(
          top: screenwidth * 0.0279,
          bottom: screenwidth * 0.0279,
          left: screenwidth * 0.0279,
          right: screenwidth * 0.0279),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xffF1F1F1), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //  height: screenwidth*0.153,
                    //  width: screenwidth*0.153,
                    width: screenwidth * 0.101,
                    //  height: screenwidth*0.153,
                    //  width: screenwidth*0.153,
                    child: Image.asset(getavatarfromInt(avatarindex)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.02),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontFamily: intersemibold,
                        color: appdarkgrey1,
                        fontSize: screenwidth * 0.0356,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: screenwidth * 0.02, right: screenwidth * 0.02),
                    child: Text(
                      username,
                      style: TextStyle(
                        fontFamily: intermedium,
                        color: applightgrey1,
                        fontSize: screenwidth * 0.0305,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: 3,
                    decoration: BoxDecoration(
                        color: applightgrey1, shape: BoxShape.circle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.02),
                    child: Text(
                      currentdateTime,
                      style: TextStyle(
                        fontFamily: interregular,
                        color: applightgrey1,
                        fontSize: screenwidth * 0.0305,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: screenwidth * 0.02),
            child: TextFormField(
              focusNode: newpostKeyboardFocusNode,
              onChanged: (v) {
                notifyListeners();
              },
              style: TextStyle(
                letterSpacing: -0.1,
                fontFamily: interregular,
                color: Color(0xff4C4C4F),
                fontSize: screenwidth * 0.038,
                height: 1.2,
              ),
              cursorColor: appdarkgrey1,
              maxLines: 3,
              keyboardType: TextInputType.name,
              controller: newposttextController,
              textInputAction: TextInputAction.done,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
//                      contentPadding: EdgeInsets.only(top: 17),
                hintText: "Type your thoughts, opinions, and take on what’s "
                    "happening around you.",
                hintStyle: TextStyle(
                  letterSpacing: -0.1,
                  fontFamily: interregular,
                  color: Colors.black.withOpacity(0.38),
                  fontSize: screenwidth * 0.038,
                ),
              ),
            ),
            /* Text(textPost.postText,
              maxLines: 12,
              style: TextStyle(
                letterSpacing: -0.1,
                fontFamily: interregular,
                color: Colors.black87,
                fontSize: screenwidth * 0.038,
              ),),*/
          ),
          SizedBox(
            height: screenwidth * 0.0377,
          ),
          Container(
            width: screenwidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: screenwidth*0.001,),
                InkWell(
                  onTap: () {
                    TextPost textPost = TextPost(
                        username: username,
                        userAvatar: avatarindex,
                        userFullName: name,
                        commentCount: 0,
                        likeCount: 0,
                        shareCount: 0,
                        datetime: currentdateTime,
                        postText: newposttextController.text);
                    oncreatePostTapped(context, textPost);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: screenwidth * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: applightgrey1,
                          size: screenwidth * 0.048,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenwidth * 0.017),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              letterSpacing: -0.1,
                              fontFamily: interregular,
                              color: Colors.black87,
                              fontSize: screenwidth * 0.036,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    TextPost textPost = TextPost(
                        username: username,
                        userAvatar: avatarindex,
                        userFullName: name,
                        commentCount: 0,
                        likeCount: 0,
                        shareCount: 0,
                        datetime: currentdateTime,
                        postText: newposttextController.text);
                    print("gere");
                    addnewPost(textPost);
                    setshowPostSuccessTrue();
                    //   shareTextPost(textPost.postText);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: newposttextController.text.length > 0
                            ? Colors.black87
                            : Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenwidth * 0.06,
                        vertical: screenwidth * 0.02),
                    margin: EdgeInsets.only(right: screenwidth * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FeatherIcons.upload,
                          color: Colors.white,
                          size: screenwidth * 0.038,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenwidth * 0.025),
                          child: Text(
                            "Post",
                            style: TextStyle(
                              letterSpacing: -0.1,
                              fontFamily: intermedium,
                              color: Colors.white,
                              fontSize: screenwidth * 0.036,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addnewPost(TextPost textPost) {
    inserttexttoDatabase(textPost);
    notifyListeners();
    setaddingNewPostFalse();
    print("here");
    updateAllPostsList();
  }

  String getTimeAgo(String dateString) {
    final now = DateTime.now();
    final date = DateFormat('MM/dd/yyyy h:mm a')
        .parse(dateString); // Parse the date string

    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m'; // Less than 1 hour, display minutes
    } else if (difference.inDays < 7) {
      return '${difference.inHours}h'; // Less than 7 days, display hours
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w'; // Display weeks
    }
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

  void shareTextPost(BuildContext context, String text, double screenwidth) {
    //  FlutterShare.share(title: "New post via Connect Me", text: text);
    try {
      FlutterShare.share(title: "New post via Connect Me", text: text);
    } catch (e) {
      // Show an error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Sharing Failed',
              style: TextStyle(
                fontFamily: intermedium,
                color: Colors.white,
                fontSize: screenwidth * 0.0507,
              ),
            ),
            content: Text(
              'An error occurred while sharing: $e',
              style: TextStyle(
                fontFamily: interregular,
                color: Colors.white,
                fontSize: screenwidth * 0.0387,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: interregular,
                    color: Colors.white,
                    fontSize: screenwidth * 0.0387,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void focusOnNewPostTextField(BuildContext context) {
    print("Focusiing noe");
    FocusScope.of(context).requestFocus(newpostKeyboardFocusNode);
  }

  void disposeOnNewPostTextField() {
    newpostKeyboardFocusNode.unfocus();
  }

  void initialDataHandlers() {
    updateAllPostsList();
  }

  Widget alladdedDBPosts(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        retrievedtextposts.isEmpty
            ? SizedBox(
                height: 0,
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: retrievedtextposts.length,
                itemBuilder: (context, index) {
                  return individualpost(
                      context, ref, retrievedtextposts[index]);
                })
        // for(int i=0;i<allposts.length;i++)individualpost(context, allposts[i])
      ],
    );
  }

  Widget createnewPostButton(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        // oncreatePostTapped(context);
        TextPost textPost = TextPost(
            username: "juliasnl",
            userAvatar: 0,
            userFullName: "Julia",
            commentCount: 0,
            likeCount: 0,
            shareCount: 0,
            datetime: DateFormat.yMd().add_jm().format(DateTime.now()),
            postText: newposttextController.text);
        oncreatePostTapped(context, textPost);
      },
      child: Container(
        width: screenwidth * 0.610,
        height: screenwidth * 0.122,
        decoration: BoxDecoration(
            color: appmainskyblue,
            borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAddingNewPost ? CupertinoIcons.xmark : FeatherIcons.plus,
              color: Colors.white,
              size: screenwidth * 0.0407,
            ),
            Container(
              margin: EdgeInsets.only(left: screenwidth * 0.02),
              child: Text(
                isAddingNewPost ? "Cancel " : "Create a new post",
                style: TextStyle(
                  fontFamily: interregular,
                  color: Colors.white,
                  fontSize: screenwidth * 0.0407,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

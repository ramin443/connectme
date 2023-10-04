import 'package:connectme/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/font_constants.dart';
import '../../providers/all_providers.dart';

class Home extends ConsumerWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    final viewChangeNotifierState = ref.watch(viewChangeNotifier);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
          width: screenwidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenwidth * 0.12,
              ),
              topRow(context, ref),
              SizedBox(
                height: screenwidth * 0.03,
              ),
              viewChangeNotifierState.pageTabs(context),
              SizedBox(
                height: screenwidth * 0.025,
              ),
              viewChangeNotifierState.postAddedIndicator(context),

              viewChangeNotifierState.newpostRow(context, ref),
              // viewChangeNotifierState.isAddingNewPost?
              //  viewChangeNotifierState.newpost(context,viewChangeNotifierState.alltextposts[0])
              viewChangeNotifierState.alladdedDBPosts(context, ref),
              //alladdedposts(context,ref),
              viewChangeNotifierState.getPostsBasedonTab(context, ref),
              SizedBox(
                height: screenwidth * 0.2,
              )
              /*  Container(
                height: screenheight,
                width: screenwidth,
                child:
                    ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: alltextposts.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                  return individualpost(context);
                })),*/
            ],
          )),
    );
  }

  Widget alladdedposts(BuildContext context, WidgetRef ref) {
    final futurePostsList = ref.watch(postsStreamProvider);
    final viewChangeNotifierState = ref.watch(viewChangeNotifier);
    return futurePostsList.when(data: (data) {
      viewChangeNotifierState.initialDataHandlers();
      return viewChangeNotifierState.alladdedDBPosts(context, ref);
    }, error: (e, s) {
      return Container(
        child: Text("Error loading + $e"),
      );
    }, loading: () {
      return CircularProgressIndicator();
    });
  }

  Widget topRow(BuildContext context, WidgetRef ref) {
    final userChangeNotifierState = ref.watch(userChangeNotifier);
    final viewChangeNotifierState = ref.watch(viewChangeNotifier);
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenwidth,
      padding: EdgeInsets.only(
          left: screenwidth * 0.0818, right: screenwidth * 0.0818),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //   margin:EdgeInsets.only(bottom: -8),
            //     margin: EdgeInsets.only(top: 3),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontFamily: tiemposfineregularitalic,
                      color: Colors.black87,
                      fontSize: screenwidth * 0.0713,
                    ),
                    children: [
                  TextSpan(text: "Welcome\n"),
                  TextSpan(
                    text: userChangeNotifierState.retrieveduserdata.isNotEmpty
                        ? userChangeNotifierState.retrieveduserdata[0].name
                        : "Julia",
                    style: TextStyle(
                      fontFamily: tiemposfineregular,
                      color: Colors.black87,
                      fontSize: screenwidth * 0.0713,
                    ),
                  ),
                ])),
          ),
          Container(
            //  height: screenwidth*0.153,
            //  width: screenwidth*0.153,
            child: Image.asset(
              userChangeNotifierState.retrieveduserdata.isNotEmpty
                  ? viewChangeNotifierState.getavatarfromInt(
                      userChangeNotifierState.retrieveduserdata[0].avatarIndex)
                  : appavatar0,
              width: screenwidth * 0.163,
            ),
          )
        ],
      ),
    );
  }
}

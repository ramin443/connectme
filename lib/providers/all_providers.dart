import 'package:connectme/changenotifiers/profile_notifier.dart';
import 'package:connectme/changenotifiers/user_notifier.dart';
import 'package:connectme/changenotifiers/view_notifier.dart';
import 'package:connectme/datamodels/textPost_Model.dart';
import 'package:connectme/dbhelpers/post_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final viewChangeNotifier=ChangeNotifierProvider<ViewChangeNotifier>((ref){
  return ViewChangeNotifier();
});
final userChangeNotifier=ChangeNotifierProvider<UserChangeNotifier>((ref){
  return UserChangeNotifier();
});
final profileChangeNotifier=ChangeNotifierProvider<ProfileNotifier>((ref){
  return ProfileNotifier();
});
final postsStreamProvider=FutureProvider<List<TextPost>>((ref){
  return DatabaseHelper().getAllTextPosts();
});
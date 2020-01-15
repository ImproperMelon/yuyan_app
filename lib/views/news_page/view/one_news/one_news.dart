import 'package:flutter/material.dart';
import 'package:yuyan_app/models/component/appUI.dart';
import 'package:yuyan_app/models/component/web/open_url.dart';
import 'package:yuyan_app/models/tools/time_cut.dart';
import 'package:yuyan_app/models/widgets_small/user_avatar.dart';
import 'package:yuyan_app/models/widgets_small/user_event.dart';
import 'package:yuyan_app/state_manage/dataManage/data/news_data.dart';

class OneNewsContainer extends StatefulWidget {
  OneNewsContainer({Key key, @required this.data, this.unread: true})
      : super(key: key);
  final Notifications data;
  final bool unread;

  static final Widget sizedBox = SizedBox(height: 100);

  @override
  _OneNewsContainerState createState() =>
      _OneNewsContainerState(data: data, unread: unread);
}

class _OneNewsContainerState extends State<OneNewsContainer> {
  _OneNewsContainerState({Key key, @required this.data, @required this.unread});

  final Notifications data;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    var subTitle = data.secondSubject == null ? "" : data.secondSubject.name;
    return GestureDetector(
      onTap: () {
        var url = "https://www.yuque.com/go/notification/${data.id}";
        openUrl(context, url);
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 16),
        color: AppColors.background,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                var url = "https://www.yuque.com/${data.actor.login}";
                openUrl(context, url);
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: userAvatar(data.actor.avatarUrl, height: 45),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 81,
                  height: 26,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${data.actor.name}",
                        style: AppStyles.textStyleB,
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Text(
                            "${timeCut(data.createdAt)}",
                            style: AppStyles.textStyleCC,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 81,
                  height: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${newsType[data.notifyType] ?? data.notifyType}",
                        style: AppStyles.textStyleC,
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor:
                                unread ? Colors.red : Colors.transparent,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 几种通知
Map<String, String> newsType = {
  "invite_collaborator": "邀请你协作",
  "update_doc": "更新了文档",
  "like_doc": "打赏了稻谷",
  "comment": "评论了话题",
  "mention": "在评论中@了你",
  "new_topic": "新建了讨论",
  "new_book": "新建了知识库",
  "topic_assign": "指派了话题",
  "publish_doc": "发布了文章",
  "watch_book": "关注了知识库",
  "follow_user": "关注了你",
  "like_artboard": "给你的画板赞赏了稻谷",
  "upload_artboards": "更新了画板",
  "apply_join_group": "申请加入团队",
  "join_group_user": "添加了团队成员",
};
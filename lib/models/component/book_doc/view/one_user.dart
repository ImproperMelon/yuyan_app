import 'package:flutter/material.dart';
import 'package:yuyan_app/models/component/appUI.dart';
import 'package:yuyan_app/models/component/open_page.dart';
import 'package:yuyan_app/models/tools/clear_text.dart';
import 'package:yuyan_app/models/tools/get_tag.dart';
import 'package:yuyan_app/models/widgets_small/user_avatar.dart';

Widget oneMember(BuildContext context, Map data) {
  String tag = getTag();
  return GestureDetector(
    onTap: () {
      OpenPage.user(
        context,
        tag: tag,
        login: data["login"],
        userId: data["userId"],
        avatarUrl: data["avatarUrl"],
        description: data["description"],
        name: data["name"],
      );
    },
    child: Container(
      height: 70,
      margin: EdgeInsets.only(left: 15, top: 10, right: 15),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            offset: Offset(1, 2),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20),
          userAvatar(data["avatarUrl"], height: 50),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            margin: EdgeInsets.only(left: 20),
            child: data["description"] != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          clearText(data["name"], 10),
                          style: AppStyles.textStyleB,
                        ),
                      ),
                      SizedBox(height: 2),
                      Container(
                        child: Text(
                          "${clearText(data['description'], 15)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStyleC,
                        ),
                      ),
                    ],
                  )
                : Container(
                    child: Text(
                      "${data['name']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textStyleB,
                    ),
                  ),
          ),
          Spacer(),
          // FollowButtom(data: data)
        ],
      ),
    ),
  );
}

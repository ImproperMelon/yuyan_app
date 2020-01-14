import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:yuyan_app/models/net/requests/dio_requests.dart';
import 'package:yuyan_app/models/tools/write_json.dart';
import 'package:yuyan_app/state_manage/dataManage/data/attent_data.dart';

// 几种动态
Map<String, String> eventType = {
  "update_doc": "更新了文档",
  "like_doc": "打赏了稻谷",
  "publish_doc": "发布了文章",
  "watch_book": "关注了知识库",
  "follow_user": "关注了雀友",
  "like_artboard": "给画板赞赏了稻谷",
  "upload_artboards": "更新了画板"
};

// 由于数据过于复杂，快哭了，难以序列化，在这预先处理数据
Map<String, dynamic> fixAttentData(Map<String, dynamic> data) {
  Map<String, dynamic> lastData = {};
  List dataList = [];
  for (Map<String, dynamic> i in data["data"]) {
    Map<String, dynamic> oneData = {};
    oneData["who"] = i["actor"]["name"];
    oneData["user_id"] = i["actor"]["id"];
    oneData["login"] = i["actor"]["login"];
    oneData["avatar_url"] = i["actor"]["avatar_url"];
    oneData["did"] = eventType[i["event_type"]] ?? i["event_type"];
    oneData["when"] = i["created_at"];
    oneData["subject_type"] = i["subject_type"];
    oneData["event"] = [];
    Map<String, dynamic> subject = i["subject"];

    if (!i.containsKey("subjects")) {
      // 如果 没有多个 subjects

      Map<String, dynamic> event = {};
      event["count"] = subject["likes_count"] ??
          subject["followers_count"] ??
          subject["watches_count"] ??
          0;
      event["title"] = subject["name"] ?? subject["title"] ?? "";
      event["description"] = subject["description"] ?? "";
      event["avatar_url"] =
          subject["avatar_url"] ?? subject["user"]["avatar_url"] ?? "";
      event["image"] = subject["image"] ?? "";

      Map secondSubject = i["second_subject"] ?? {};

      String atwho = subject.keys.toList().contains("login")
          ? subject["login"]
          : subject["user"]["login"];
      String bookSlug = secondSubject.containsKey("slug")
          ? ('/' + secondSubject["slug"])
          : "";
      String slug = subject.containsKey("slug") ? ('/' + subject["slug"]) : "";

      event["url"] = "https://www.yuque.com/" + atwho + bookSlug + slug;
      if (i["event_type"] == "upload_artboards") {
        // 如果是更新了画板，获得 image url
        // avatar_url 使用作者的头像 book_id 作为图片id
        oneData["subject_type"] = "Artboard";
        event["image"] = i["params"]["artboards"][0]["image"];
        event["book_id"] = i["params"]["artboards"][0]["id"];
      }
      oneData["event"].add(event);
    } else {
      if (i["event_type"] == "upload_artboards") {
        Map<String, dynamic> event = {};
        oneData["subject_type"] = "Artboard";

        for (Map image in i["params"]["artboards"]) {
          event["title"] = subject["name"] ?? subject["title"] ?? "";
          event["book_id"] = image["id"];
          event["image"] = image["image"];
          event["avatar_url"] = subject["user"]["avatar_url"];
          String atwho = subject.keys.toList().contains("login")
              ? subject["login"]
              : subject["user"]["login"];
          Map secondSubject = i["second_subject"] ?? {};
          String bookSlug = secondSubject.containsKey("slug")
              ? ('/' + secondSubject["slug"])
              : "";
          event["url"] = "https://www.yuque.com/" + atwho + bookSlug;
          oneData["event"].add(event);
        }
      } else {
        // 关注了多个用户或多个知识库
        for (Map sub in i["subjects"]) {
          Map<String, dynamic> event = {};
          event["count"] = subject["likes_count"] ??
              subject["followers_count"] ??
              subject["watches_count"] ??
              0;
          event["title"] = sub["name"];
          event["description"] = sub["description"];
          event["image"] = "";
          event["book_id"] = sub["book_id"] ?? 0;
          event["avatar_url"] = sub["avatar_url"] ?? "";
          String slug = sub["slug"] ?? "";
          event["url"] =
              "https://www.yuque.com/" + sub["user"]["login"] + "/" + slug;
          oneData["event"].add(event);
        }
      }
    }

    dataList.add(oneData);
  }
  lastData["data"] = dataList;
  lastData["offset"] = data["meta"]["offset"];

  return lastData;
}

class AttentManage extends Model {
  int offset = 0;
  AttentData _attentData = AttentData(data: []);
  AttentData get attentData => _attentData;

  getSaveData() async {
    var attentEvent = await readJson('events');
    AttentData attentionData = AttentData.fromJson(attentEvent);
    _attentData = attentionData;
    notifyListeners();
    return attentionData;
  }

  getMoreData() async {
    var dioData = await DioReq.get("/events?offset=$offset");
    Map mapData = fixAttentData(dioData);
    AttentData attentionData = AttentData.fromJson(mapData);
    offset = attentionData.offset;
    _attentData.data.addAll(attentionData.data);
  }

  saveEventsData() async {
    var dioData = await DioReq.get("/events?offset=0");
    Map mapData = fixAttentData(dioData);

    offset = mapData["offset"];
    await writeJson('events', mapData);
    return 1;
  }

  void update() {
    saveEventsData().then((res) {
      getSaveData();
    });
  }
}
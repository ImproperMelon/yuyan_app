import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuyan_app/state_manage/account/color_manage.dart';
import 'get_pref.dart';

class TopStateModel extends Model {
  ColorManage colorManage = ColorManage();
}

// class Name1 extends TopStateModel {}
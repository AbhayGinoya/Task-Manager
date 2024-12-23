import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/app_colors.dart';
import 'package:task_manager/core/utils/extension.dart';

enum Status {
  all(AppColors.white),
  open(Colors.blue),
  cancel(Colors.redAccent),
  pending(Colors.orangeAccent),
  completed(Colors.green);


  final Color color;

  static Color find (String status) => switch(status) {
    "Pending" => pending.color,
    "Open" => open.color,
    "Cancel" => cancel.color,
    "Completed" => completed.color,
    String() => pending.color,
  };

  const Status(this.color);

  @override
  String toString() {
    return name.capitalizeFist;
  }
}

enum DateFormats {
  DD_MM_YYYY("dd-MM-yyyy"),
  DD_MMM_YYYY("dd MMM,yyyy"),
  MMM_YYYY("MMM, yyyy"),
  MMM_DD_HH_MM_AA("MMM dd, hh:mm aa"),
  YYYY_MM_DD_HH_MM_SS("yyyy-MM-dd hh:mm:ss"),
  HH_MM_AA("hh:mm aa"),
  HH_MM_SS("hh:mm:ss");

  final String format;
  const DateFormats(this.format);
}
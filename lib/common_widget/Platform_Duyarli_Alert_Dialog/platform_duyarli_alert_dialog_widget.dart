// import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformDuyarliAlertDialogWidget extends StatelessWidget {
  Widget buildAndroidWidget(BuildContext context);

  Widget buildIOSWidget(BuildContext context);
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildIOSWidget(context);
    } else {
      return buildAndroidWidget(context);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (Platform.isIOS) {
  //     //7/15:12
  //     return buildIOSWidget(context);
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   if (true) {
  //     //7/15:12
  //     return buildAndroidWidget(context);
  //   }
  // }
}

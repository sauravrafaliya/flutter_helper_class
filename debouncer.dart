
import 'dart:async';

import 'package:flutter/foundation.dart';

class DeBouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: 700),
      action,
    );
  }
}
import 'dart:async';

import 'src/app.dart';
import 'src/common/logger.dart';

void run() => runZonedGuarded(
      App.run,
      (error, stack) => severe(error, stack),
    );

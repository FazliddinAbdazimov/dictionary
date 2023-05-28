import 'dart:developer' as developer;

final bool _$debugMode = () {
  var debug = false;
  assert(debug = true);
  return debug;
}();

final void Function(Object? message) fine = _logAll('FINE', 500);

final void Function(Object? message) config = _logAll('CONF', 700);

final void Function(Object? message) info = _logAll('INFO', 800);

final void Function(Object exception, [StackTrace? stackTrace, String? reason]) warning = _logAll('WARN', 900);

final void Function(Object error, [StackTrace stackTrace, String? reason]) severe = _logAll('ERR!', 1000);

void Function(
  Object? message, [
  StackTrace? stackTrace,
  String? reason,
]) _logAll(String prefix, int level) => (Object? message, [StackTrace? stackTrace, String? reason]) {
      //if (Zone.current[kLogEnabled] != true) return;
      if (_$debugMode) {
        developer.log(
          '${reason ?? message}',
          level: level,
          name: 'server',
          error: (message is Exception || message is Error) ? message : null,
          stackTrace: stackTrace,
        );
      }
    };

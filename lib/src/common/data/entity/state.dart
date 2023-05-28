import 'dictionary.dart';

enum CustomState {
  error,
  waiting,
  success,
}

class SomeState {
  final String errorText;
  final CustomState state;
  final Dictionary? dictionary;

  const SomeState({
    required this.errorText,
    required this.state,
    this.dictionary,
  });
}

import 'dart:convert';

import '../../../common/data/api/api_base.dart';
import '../../../common/data/entity/dictionary.dart';
import '../../../common/data/entity/state.dart';

abstract class SearchUseCase {
  static Future<SomeState> getSearchedtext(String text) async {
    final response = await ApiBase.request(text);

    final dictionary = Dictionary.fromJson(jsonDecode(response));

    return SomeState(
      state: CustomState.success,
      dictionary: dictionary,
      errorText: '',
    );
  }
}

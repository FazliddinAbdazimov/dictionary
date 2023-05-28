import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../common/data/entity/state.dart';
import '../../../common/data/exception/exceptions.dart';
import '../domain/usecase.dart';

part 'components/app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;

  StreamController<SomeState?>? _streamController;
  Stream<SomeState?>? _stream;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    _streamController = StreamController<SomeState?>();
    _stream = _streamController?.stream;
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamController?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(
        search: _search,
        controller: _controller,
        onChanged: (String text) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 1000), _search);
        },
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("Qidiriladigan so'zni kiriting"),
              );
            }

            if (snapshot.data?.state == CustomState.error) {
              return Center(
                child: Text(snapshot.data?.errorText ?? ''),
              );
            }

            if (snapshot.data?.state == CustomState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final definitions = snapshot.data?.dictionary?.definitions;

            return ListView.builder(
              itemCount: definitions?.length,
              itemBuilder: (context, index) {
                return ListBody(
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (definitions?[index].imageUrl != null) ...{
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        definitions?[index].imageUrl ?? '',
                                      ),
                                    ),
                                  ),
                                },
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Text(
                                    "${_controller.text.trim()} (${definitions?[index].type})",
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 27,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                "Izohi:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                definitions?[index].definition ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  _search() async {
    if (_controller.text.isEmpty) {
      _streamController?.add(null);
      return;
    }

    _streamController?.add(
      const SomeState(
        state: CustomState.waiting,
        errorText: '',
      ),
    );

    try {
      final data = await SearchUseCase.getSearchedtext(
        _controller.text.trim(),
      ).timeout(const Duration(seconds: 20));
      _streamController?.add(data);
    } on ConnectionException {
      _streamController?.add(
        const SomeState(
          state: CustomState.error,
          errorText: "Internet ulanganligini tekshiring",
        ),
      );
    } on Object catch (e) {
      if (e is DioError && e.response!.statusCode! < 500) {
        _streamController?.add(
          const SomeState(
            state: CustomState.error,
            errorText: "Izlanayotgan so'z topilmadi",
          ),
        );
      } else {
        _streamController?.add(
          const SomeState(
            state: CustomState.error,
            errorText: "Hatolik yuzberdi keyinroq urunib ko'ring",
          ),
        );
      }
    }
  }
}

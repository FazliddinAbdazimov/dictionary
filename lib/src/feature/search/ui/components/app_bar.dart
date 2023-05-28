part of '../search_screen.dart';

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final void Function() search;
  final void Function(String)? onChanged;

  const _CustomAppBar({
    required this.controller,
    required this.search,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Shaxsiy Lug'at",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFFF5A5A),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onChanged: onChanged,
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "So'zni izlang",
                    contentPadding: EdgeInsets.only(left: 24.0),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  cursorHeight: 20,
                  autocorrect: true,
                ),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              icon: const Icon(Icons.search),
              onPressed: search,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}

/*


*/
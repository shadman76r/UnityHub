import 'package:flutter/material.dart';

class ReactionPicker extends StatelessWidget {
  final void Function(String reaction) onPick;

  const ReactionPicker({super.key, required this.onPick});

  static const reactions = ["👍", "❤️", "😂", "😮", "😢", "😡"];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(blurRadius: 18, color: Color(0x22000000), offset: Offset(0, 10)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final r in reactions)
              InkWell(
                onTap: () => onPick(r),
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(r, style: const TextStyle(fontSize: 22)),
                ),
              )
          ],
        ),
      ),
    );
  }
}

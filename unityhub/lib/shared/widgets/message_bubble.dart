import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final bool fromMe;
  final String text;
  final String time;

  // UI-only extras
  final bool seen;
  final String? reaction;     // e.g. 👍
  final String? replyPreview; // "Alex: hello..."
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.fromMe,
    required this.text,
    required this.time,
    this.seen = false,
    this.reaction,
    this.replyPreview,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Theme (Step 4)
    final bg = fromMe
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFF4B91FF)],
          )
        : const LinearGradient(
            colors: [Colors.white, Colors.white],
          );

    final fg = fromMe ? Colors.white : AppColors.textDark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Align(
        alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: onLongPress,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: bg,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(fromMe ? 16 : 4),
                        bottomRight: Radius.circular(fromMe ? 4 : 16),
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 14, color: Color(0x16000000), offset: Offset(0, 8)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (replyPreview != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: fromMe ? Colors.white.withOpacity(.18) : const Color(0xFFF2F4F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                replyPreview!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: fromMe ? Colors.white.withOpacity(.9) : AppColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          Text(text, style: TextStyle(color: fg, fontSize: 14, height: 1.25)),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(time, style: TextStyle(color: fg.withOpacity(.78), fontSize: 11)),
                              if (fromMe) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  seen ? Icons.done_all : Icons.done,
                                  size: 14,
                                  color: fg.withOpacity(.85),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (reaction != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6)),
                    ],
                  ),
                  child: Text(reaction!, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

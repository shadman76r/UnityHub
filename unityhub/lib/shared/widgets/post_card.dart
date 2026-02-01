import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PostCard extends StatelessWidget {
  final String name;
  final String time;
  final String content;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.name,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(.12),
                child: Text(name.characters.first, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          ),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 15, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 18),
              const SizedBox(width: 6),
              Text("$likes"),
              const SizedBox(width: 16),
              const Icon(Icons.mode_comment_outlined, size: 18),
              const SizedBox(width: 6),
              Text("$comments"),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                label: const Text("Like"),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.mode_comment_outlined, size: 18),
                label: const Text("Comment"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/mock/dummy_data.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "UnityHub",
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        actions: [
          _CircleIconButton(icon: Icons.search, onTap: () {}),
          _CircleIconButton(icon: Icons.chat_bubble_outline, onTap: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: const [
          SizedBox(height: 10),
          _ComposerCard(),
          SizedBox(height: 10),
          _StoriesRow(),
          SizedBox(height: 8),
          Divider(height: 1),
          _FeedPosts(),
          SizedBox(height: 90),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreatePostSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _openCreatePostSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _CreatePostSheet(),
  );
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  const _ComposerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(.12),
                child: Text(
                  DummyData.userName.characters.first,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _openCreatePostSheet(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "What's on your mind?",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ComposerAction(
                icon: Icons.videocam,
                label: "Live",
                onTap: () => _openCreatePostSheet(context),
              ),
              _ComposerAction(
                icon: Icons.photo_library,
                label: "Photo",
                onTap: () => _openCreatePostSheet(context),
              ),
              _ComposerAction(
                icon: Icons.emoji_emotions_outlined,
                label: "Feeling",
                onTap: () => _openCreatePostSheet(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ComposerAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _CreatePostSheet extends StatelessWidget {
  const _CreatePostSheet();

  void _goToCreatePost(BuildContext context) {
    Navigator.pop(context); // close sheet
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 6,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withOpacity(.12),
                  child: Text(
                    DummyData.userName.characters.first,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Create post",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Quick action (like facebook: "Write something...")
            InkWell(
              onTap: () => _goToCreatePost(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Write something...",
                  style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Options list
            _SheetItem(
              icon: Icons.photo_library_outlined,
              title: "Photo/Video",
              subtitle: "Share photos or a short video",
              onTap: () => _goToCreatePost(context),
            ),
            _SheetItem(
              icon: Icons.videocam_outlined,
              title: "Live video",
              subtitle: "Start a live stream (UI only)",
              onTap: () => Navigator.pop(context),
            ),
            _SheetItem(
              icon: Icons.emoji_emotions_outlined,
              title: "Feeling/Activity",
              subtitle: "Share how you feel",
              onTap: () => _goToCreatePost(context),
            ),
            _SheetItem(
              icon: Icons.location_on_outlined,
              title: "Check in",
              subtitle: "Add a location (UI only)",
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted)),
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: DummyData.stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final s = DummyData.stories[i];
          final isMe = s["isMe"] as bool;
          final name = s["name"] as String;

          return Container(
            width: 90,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withOpacity(.12),
                      child: Text(
                        name.characters.first,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (isMe)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  isMe ? "Add story" : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeedPosts extends StatelessWidget {
  const _FeedPosts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final p in DummyData.posts) _PostCard(p: p),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> p;
  const _PostCard({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withOpacity(.12),
                  child: Text(
                    (p["name"] as String).characters.first,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p["name"] as String, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(p["time"] as String,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              p["content"] as String,
              style: const TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.thumb_up_alt, size: 16),
                const SizedBox(width: 6),
                Text("${p["likes"]}"),
                const Spacer(),
                Text("${p["comments"]} comments • ${p["shares"]} shares",
                    style: const TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _PostAction(icon: Icons.thumb_up_alt_outlined, label: "Like"),
                _PostAction(icon: Icons.mode_comment_outlined, label: "Comment"),
                _PostAction(icon: Icons.reply_outlined, label: "Share"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PostAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

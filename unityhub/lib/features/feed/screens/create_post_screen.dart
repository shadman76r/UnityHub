import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/mock/dummy_data.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final text = TextEditingController();

  // UI-only selected media (dummy urls)
  final List<String> selectedMedia = [...DummyData.dummyMedia];

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  void removeMedia(int index) {
    setState(() => selectedMedia.removeAt(index));
  }

  void addDummyMedia() {
    // UI only: add a new random image
    final next = "https://picsum.photos/seed/uh${DateTime.now().millisecondsSinceEpoch}/400/400";
    setState(() => selectedMedia.add(next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("POST", style: TextStyle(fontWeight: FontWeight.w900)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Header (like Facebook)
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(.12),
                child: Text(
                  DummyData.userName.characters.first,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DummyData.userName, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    _PrivacyChip(
                      text: "Public",
                      onTap: () => _showPrivacySheet(context),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Text composer
          TextField(
            controller: text,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Add Photo/Video bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.photo_library_outlined),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Add Photos/Videos",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                FilledButton.tonal(
                  onPressed: addDummyMedia, // UI only
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Media preview grid (Facebook-like)
          if (selectedMedia.isNotEmpty) ...[
            const Text("Preview", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 10),
            _MediaGrid(
              urls: selectedMedia,
              onRemove: removeMedia,
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "No media selected. Tap “Add” to add dummy photos.",
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],

          const SizedBox(height: 18),

          // Extra actions (UI only)
          _ActionRow(
            icon: Icons.emoji_emotions_outlined,
            title: "Feeling/Activity",
            onTap: () {},
          ),
          _ActionRow(
            icon: Icons.location_on_outlined,
            title: "Check in",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MediaGrid extends StatelessWidget {
  final List<String> urls;
  final void Function(int index) onRemove;

  const _MediaGrid({required this.urls, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: urls.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (_, i) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                urls[i],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: InkWell(
                onTap: () => onRemove(i),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionRow({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: onTap,
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PrivacyChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.06),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public, size: 16),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}

void _showPrivacySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _PrivacyOption(icon: Icons.public, title: "Public", subtitle: "Anyone can see this (UI only)"),
              _PrivacyOption(icon: Icons.people, title: "Friends", subtitle: "Only friends can see (UI only)"),
              _PrivacyOption(icon: Icons.lock, title: "Only me", subtitle: "Private (UI only)"),
            ],
          ),
        ),
      );
    },
  );
}

class _PrivacyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PrivacyOption({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle),
      onTap: () => Navigator.pop(context),
    );
  }
}

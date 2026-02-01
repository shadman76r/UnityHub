import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/mock/dummy_data.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final query = TextEditingController();
  late List<Map<String, dynamic>> items;

  @override
  void initState() {
    super.initState();
    items = DummyData.chats.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  void onSearch(String v) {
    final text = v.trim().toLowerCase();
    setState(() {
      if (text.isEmpty) {
        items = DummyData.chats.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        items = DummyData.chats
            .where((c) => (c["name"] as String).toLowerCase().contains(text))
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: TextField(
              controller: query,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: "Search people",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 6, bottom: 20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final c = items[i];
                final name = c["name"] as String;
                final unread = c["unread"] as int;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 220 + (i * 30)),
                  curve: Curves.easeOut,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(offset: Offset(0, 12 * (1 - t)), child: child),
                  ),
                  child: _ChatTile(
                    name: name,
                    last: c["last"] as String,
                    time: c["time"] as String,
                    unread: unread,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatScreen(title: name)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatefulWidget {
  final String name;
  final String last;
  final String time;
  final int unread;
  final VoidCallback onTap;

  const _ChatTile({
    required this.name,
    required this.last,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<_ChatTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final first = widget.name.characters.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapCancel: () => setState(() => pressed = false),
        onTapUp: (_) => setState(() => pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6)),
              ],
              border: Border.all(
                color: widget.unread > 0 ? AppColors.primary.withOpacity(.25) : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Hero(
                  tag: "avatar_${widget.name}",
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withOpacity(.12),
                    child: Text(first, style: const TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                fontWeight: widget.unread > 0 ? FontWeight.w900 : FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(widget.time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontWeight: widget.unread > 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: widget.unread > 0
                      ? Container(
                          key: ValueKey(widget.unread),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            "${widget.unread}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/mock/dummy_data.dart';
import '../../../shared/widgets/message_bubble.dart';
import '../../../shared/widgets/reaction_picker.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  const ChatScreen({super.key, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final input = TextEditingController();
  final scroll = ScrollController();

  // Messages (UI only)
  final List<Map<String, dynamic>> messages = [];

  // Reply state (Step 1)
  Map<String, dynamic>? replyingTo;

  // Typing indicator (Step 2)
  bool otherTyping = false;
  Timer? typingTimer;
  late final AnimationController dotsController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void initState() {
    super.initState();
    for (final m in DummyData.messages) {
      messages.add({
        "id": UniqueKey().toString(),
        "fromMe": m["fromMe"],
        "text": m["text"],
        "time": m["time"],
        "seen": (m["fromMe"] == true) ? true : false,
        "reaction": null,
        "replyToText": null,
        "replyToName": null,
      });
    }
  }

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    typingTimer?.cancel();
    dotsController.dispose();
    super.dispose();
  }

  void startReply(Map<String, dynamic> msg) {
    setState(() => replyingTo = msg);
  }

  void cancelReply() {
    setState(() => replyingTo = null);
  }

  void _showTypingForAWhile() {
    typingTimer?.cancel();
    setState(() => otherTyping = true);
    typingTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => otherTyping = false);
    });
  }

  void send() {
    final text = input.text.trim();
    if (text.isEmpty) return;

    final reply = replyingTo;
    input.clear();

    setState(() {
      messages.add({
        "id": UniqueKey().toString(),
        "fromMe": true,
        "text": text,
        "time": "Now",
        "seen": false,
        "reaction": null,
        "replyToText": reply?["text"],
        "replyToName": reply == null ? null : (reply["fromMe"] == true ? "You" : widget.title),
      });
      replyingTo = null;
    });

    // Scroll down
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      scroll.animateTo(
        scroll.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });

    // Fake seen + typing indicator (UI only)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        final last = messages.last;
        last["seen"] = true;
      });
    });

    _showTypingForAWhile();
  }

  void openReactionsPicker(int index, Offset anchor) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: () => entry.remove(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: anchor.dx - 120,
              top: anchor.dy - 60,
              child: ReactionPicker(
                onPick: (reaction) {
                  setState(() => messages[index]["reaction"] = reaction);
                  entry.remove();
                },
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Hero(
              tag: "avatar_${widget.title}",
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(.12),
                child: Text(widget.title.characters.first, style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    otherTyping ? "Typing…" : "Active now",
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_outlined)),
        ],
      ),

      // Step 4: wallpaper theme
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF6F7FB),
                    Color(0xFFF0F4FF),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: messages.length + (otherTyping ? 1 : 0),
                  itemBuilder: (context, i) {
                    // Typing indicator row
                    if (otherTyping && i == messages.length) {
                      return _TypingBubble(controller: dotsController);
                    }

                    final m = messages[i];
                    final replyName = m["replyToName"] as String?;
                    final replyText = m["replyToText"] as String?;
                    final replyPreview = (replyName != null && replyText != null)
                        ? "$replyName: $replyText"
                        : null;

                    return _SwipeReplyWrapper(
                      onReply: () => startReply(m),
                      child: Builder(
                        builder: (ctx) {
                          return MessageBubble(
                            fromMe: m["fromMe"] as bool,
                            text: m["text"] as String,
                            time: m["time"] as String,
                            seen: (m["seen"] as bool?) ?? false,
                            reaction: m["reaction"] as String?,
                            replyPreview: replyPreview,
                            onLongPress: () async {
                              final box = ctx.findRenderObject() as RenderBox?;
                              if (box == null) return;
                              final pos = box.localToGlobal(Offset(box.size.width * 0.5, 0));
                              openReactionsPicker(i, pos);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Reply preview bar (Step 1)
              if (replyingTo != null)
                _ReplyPreviewBar(
                  name: (replyingTo!["fromMe"] == true) ? "You" : widget.title,
                  text: replyingTo!["text"] as String,
                  onClose: cancelReply,
                ),

              _ChatInputBar(
                controller: input,
                onSend: send,
                onTyping: _showTypingForAWhile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------- Step 1: Swipe to reply wrapper ----------
class _SwipeReplyWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;

  const _SwipeReplyWrapper({required this.child, required this.onReply});

  @override
  State<_SwipeReplyWrapper> createState() => _SwipeReplyWrapperState();
}

class _SwipeReplyWrapperState extends State<_SwipeReplyWrapper> {
  double dx = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        setState(() => dx = (dx + d.delta.dx).clamp(0, 70));
      },
      onHorizontalDragEnd: (_) {
        if (dx > 40) widget.onReply();
        setState(() => dx = 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(dx, 0, 0),
        child: widget.child,
      ),
    );
  }
}

// -------- Step 2: Typing indicator bubble ----------
class _TypingBubble extends StatelessWidget {
  final AnimationController controller;
  const _TypingBubble({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, 6))],
        ),
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final t = controller.value;
            final d1 = (t * 3).floor() % 3 >= 0 ? 1.0 : 0.3;
            final d2 = (t * 3).floor() % 3 >= 1 ? 1.0 : 0.3;
            final d3 = (t * 3).floor() % 3 >= 2 ? 1.0 : 0.3;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(opacity: d1),
                const SizedBox(width: 6),
                _Dot(opacity: d2),
                const SizedBox(width: 6),
                _Dot(opacity: d3),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double opacity;
  const _Dot({required this.opacity});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: 8,
        width: 8,
        decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle),
      ),
    );
  }
}

// -------- Reply preview bar ----------
class _ReplyPreviewBar extends StatelessWidget {
  final String name;
  final String text;
  final VoidCallback onClose;

  const _ReplyPreviewBar({required this.name, required this.text, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x14000000), offset: Offset(0, -6))],
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(.06)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Replying to $name", style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}

// -------- Input bar ----------
class _ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onTyping;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.onTyping,
  });

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final v = widget.controller.text.trim().isNotEmpty;
      if (v != hasText) setState(() => hasText = v);
      if (widget.controller.text.isNotEmpty) widget.onTyping(); // UI-only typing trigger
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Row(
          children: [
            _IconPill(icon: Icons.add, onTap: () {}),
            const SizedBox(width: 8),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(blurRadius: 10, color: Color(0x12000000), offset: Offset(0, 5)),
                  ],
                  border: Border.all(
                    color: hasText ? AppColors.primary.withOpacity(.25) : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: hasText
                  ? _SendButton(key: const ValueKey("send"), onTap: widget.onSend)
                  : _IconPill(key: const ValueKey("mic"), icon: Icons.mic_none, onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconPill({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.06),
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 42,
        width: 42,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.send, color: Colors.white, size: 20),
      ),
    );
  }
}

// -------- Step 4: subtle wallpaper dots ----------
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1877F2);
    const gap = 26.0;
    const r = 1.6;
    for (double y = 12; y < size.height; y += gap) {
      for (double x = 12; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

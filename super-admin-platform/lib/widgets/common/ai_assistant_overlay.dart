import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AiAssistantOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const AiAssistantOverlay({super.key, required this.onClose});

  @override
  State<AiAssistantOverlay> createState() => _AiAssistantOverlayState();
}

class _AiAssistantOverlayState extends State<AiAssistantOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<String> _suggestions = [
    'Show critical AI alerts',
    'Analyze fleet efficiency',
    'Show driver risk report',
    'Detect fuel anomalies',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    _addSystemMessage('AI Assistant', 'Good morning, Admin. All systems are operational. I have 23 active alerts to review.');
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addSystemMessage(String sender, String text) {
    setState(() => _messages.add(ChatMessage(sender: sender, text: text, isUser: false)));
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() => _messages.add(ChatMessage(sender: 'You', text: text, isUser: true)));
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _addSystemMessage('AI Assistant', _generateResponse(text));
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('alert')) {
      return 'I found 23 active AI alerts. 2 are critical: Driver fatigue risk for John M. and a fraud attempt blocked in verification #8921.';
    }
    if (q.contains('fleet') || q.contains('efficiency')) {
      return 'Fleet efficiency is at 90%. Fuel consumption decreased 3.2% this month. 4 trucks need maintenance attention.';
    }
    if (q.contains('risk') || q.contains('driver')) {
      return 'Driver risk analysis: 1 high-risk (Omar Hassan - fraud probability 68.3%), 2 medium-risk, 3 low-risk drivers pending review.';
    }
    if (q.contains('fuel')) {
      return 'Fuel anomaly detected on Truck #4423: consumption spike 23% above baseline. Possible theft or mechanical issue.';
    }
    return 'I\'m monitoring all systems. Currently 1,284 trucks active, 892 drivers online, 3,456 active deliveries. Revenue is up 8.7% this month.';
  }

  void _close() {
    _controller.reverse().then((_) {
      if (mounted) widget.onClose();
    });
  }

  void _sendMessage() {
    final value = _textController.text.trim();
    if (value.isEmpty) return;
    _addUserMessage(value);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onTap: _close,
            child: Container(
              color: Colors.black.withValues(alpha: 0.25 * _fadeAnimation.value),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Transform.translate(
                    offset: Offset(0, 80 * _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24, bottom: 24),
                        child: SizedBox(
                          width: 420,
                          height: 600,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Material(
                                color: AppColors.surface,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: AppColors.glassBorder),
                                ),
                                child: Column(
                                  children: [
                                    _buildHeader(),
                                    Expanded(child: _buildMessages()),
                                    if (_suggestions.isNotEmpty) _buildSuggestions(),
                                    _buildInput(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [AppColors.accent, AppColors.primary]),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fleetora AI', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                Text('Online • Monitoring', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
              boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.5), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _close,
            icon: const Icon(Icons.close_rounded, size: 20),
            color: AppColors.textMuted,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceLight,
              minimumSize: const Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msg.sender,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Material(
                color: msg.isUser ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(msg.isUser ? 12 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: _suggestions.map((s) {
          return ActionChip(
            label: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
            onPressed: () {
              _addUserMessage(s);
              setState(() => _suggestions.remove(s));
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Material(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Ask AI about fleet, drivers, alerts...',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: AppColors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: AppColors.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  isDense: true,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: _sendMessage,
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final bool isUser;

  ChatMessage({required this.sender, required this.text, required this.isUser});
}

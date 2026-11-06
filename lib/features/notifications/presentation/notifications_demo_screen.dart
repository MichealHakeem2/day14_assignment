import 'package:flutter/material.dart';
import 'package:shopping_app/core/constants/app_colors.dart';
import 'package:shopping_app/core/services/notification_service.dart';

class NotificationsDemoScreen extends StatefulWidget {
  const NotificationsDemoScreen({super.key});

  @override
  State<NotificationsDemoScreen> createState() => _NotificationsDemoScreenState();
}

class _NotificationsDemoScreenState extends State<NotificationsDemoScreen> {
  final NotificationService _notificationService = NotificationService.instance;
  bool _isScheduled = false;

  void _sendNow() async {
    await _notificationService.showNotification(
      title: 'HI FROM FLUTTER',
      body: 'THIS IS THE BODY OF THE NOTIFICATION',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification sent!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _scheduleFiveSeconds() async {
    setState(() => _isScheduled = true);
    await _notificationService.scheduleNotification(
      title: 'HI FROM FLUTTER',
      body: 'THIS IS THE BODY OF THE NOTIFICATION',
      seconds: 5,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification scheduled in 5 seconds!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _isScheduled = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        title: const Text(
          'Local Notifications',
          style: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Notifications & Timezone Demo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Test immediate local notifications and timezone-aware background scheduled notifications.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: _sendNow,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.send_rounded, size: 20),
                label: const Text(
                  'Send notification now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isScheduled ? null : _scheduleFiveSeconds,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isScheduled
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.access_time_rounded, size: 20),
                label: Text(
                  _isScheduled ? 'Scheduled (5s countdown)...' : 'Schedule in 5 seconds',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

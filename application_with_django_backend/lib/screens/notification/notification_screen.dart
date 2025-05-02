import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:application_with_django_backend/models/notification.dart' as app;
import 'package:application_with_django_backend/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<app.Notification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _notifications = await _notificationService.getNotifications();
    } catch (e) {
      setState(() {
        _error = 'Failed to load notifications: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);
      setState(() {
        _notifications = _notifications.map((n) {
          if (n.id == id) {
            return app.Notification(
              id: n.id,
              userId: n.userId,
              title: n.title,
              message: n.message,
              isRead: true,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification marked as read')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as read: ${e.toString()}')),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      setState(() {
        _notifications = _notifications.map((n) {
          return app.Notification(
            id: n.id,
            userId: n.userId,
            title: n.title,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
          );
        }).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark all as read: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            tooltip: 'Mark all as read',
            onPressed: _notifications.any((n) => !n.isRead) ? _markAllAsRead : null,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchNotifications,
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : _notifications.isEmpty
            ? const Center(child: Text('No notifications'))
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: notification.isRead ? Colors.grey[100] : Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    notification.message,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM d, yyyy').format(
                        DateTime.parse(notification.createdAt),
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (!notification.isRead)
                      IconButton(
                        icon: const Icon(Icons.mark_email_read, size: 20, color: Colors.blue),
                        onPressed: () => _markAsRead(notification.id),
                      ),
                  ],
                ),
                onTap: notification.isRead ? null : () => _markAsRead(notification.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
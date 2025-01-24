import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class TimelineItem {
  final String title;
  final Color color;
  final Widget icon;
  final bool isDashed;

  TimelineItem(
    this.title, {
    required this.color,
    required this.icon,
    this.isDashed = false,
  });
}

class OrderTimelineScreen extends StatelessWidget {
  const OrderTimelineScreen({Key? key, required this.n}) : super(key: key);
  final int n;
  @override
  Widget build(BuildContext context) {
    final List<TimelineItem> items = [
      TimelineItem(
        "Order Placed",
        color: Colors.green,
        icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
      ),
      TimelineItem(
        "In Progress",
        color: Colors.orange,
        icon: const Icon(Icons.hourglass_empty, color: Colors.white, size: 20),
        isDashed: getIsDashed(n),
      ),
      
      TimelineItem(
        "Completed",
        color: Colors.grey,
        icon: const Icon(Icons.check_circle, color: Colors.white, size: 20),
        isDashed: false,
      ),
    ];

    return Scaffold(
      body: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0.1,
          connectorTheme: const ConnectorThemeData(
            thickness: 2.5,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.after,
          itemCount: items.length,
          contentsBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(36.0),
            child: Text(
              items[index].title,
              style: TextStyle(
                color: items[index].color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          indicatorBuilder: (_, index) => DotIndicator(
            color: items[index].color,
            child: items[index].icon,
          ),
          connectorBuilder: (_, index, type) => items[index].isDashed
              ? DashedLineConnector(
                  color: items[index].color,
                  gap: 3,
                  dash: 3,
                )
              : SolidLineConnector(
                  color: items[index].color,
                ),
        ),
      ),
    );
  } 
  bool getIsDashed(n) {
    if (n == 1 || n == 3) {
      return true; // Only "In Progress" is dashed
    } else if (n == 2) {
      return false; // Only "Completed" is dashed
    }
    return true; // For status 3, nothing is dashed
  }
}
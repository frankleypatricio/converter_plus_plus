import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const CustomCard({required this.title, required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.w600)),
            Divider(color: AppTheme.colorScheme.primary.withOpacity(.6)),
            const SizedBox(height: 8),
            Column(children: children),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(DateTime.parse(review.createdAt)),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                    (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
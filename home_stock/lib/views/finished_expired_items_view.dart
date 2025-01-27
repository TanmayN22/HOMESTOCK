import 'package:flutter/material.dart';

class FinishedExpiredItemsView extends StatelessWidget {
  const FinishedExpiredItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expired/finished Products "
        ),
      ),
    );
  }
}

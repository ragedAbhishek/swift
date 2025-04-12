import 'package:flutter/material.dart';

class JourneyCompletePage extends StatelessWidget {
  const JourneyCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Complete'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have reached the destination!'),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate back to QR Scanner or Home
                // Navigator.of(context).pushNamedAndRemoveUntil('/qrScanner', (route) => false);
              },
              child: const Text('Scan Another Bus'),
            )
          ],
        ),
      ),
    );
  }
}

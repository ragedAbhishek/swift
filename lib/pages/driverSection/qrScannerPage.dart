import 'dart:io'; // Used for platform checks

import 'package:flutter/foundation.dart'; // Used for checking if running on web
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Import the page we want to navigate to after scanning
import 'busConfirmationPage.dart'; 

class QrScannerPage extends StatefulWidget {
  // Constructor remains simple
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  // 1. Key for the QRView widget: Helps Flutter manage the widget's state.
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); 
  
  // 2. Controller for the QRView: Allows us to control the camera (pause, resume, flash).
  QRViewController? controller; 
  
  // 3. Stores the result of the scan.
  Barcode? result; 
  
  // 4. Flag to prevent navigating multiple times if scans happen quickly.
  bool navigating = false; 

  // 5. Handle Hot Reload: Pauses/resumes camera correctly during development.
  @override
  void reassemble() {
    super.reassemble();
    // Need platform check as pauseCamera/resumeCamera behave differently or aren't available everywhere
    if (!kIsWeb) { 
      if (Platform.isAndroid) {
        controller?.pauseCamera();
      }
      controller?.resumeCamera();
    }
  }

  // 6. Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Stack to overlay controls/info on the camera view if needed later
      body: Stack( 
        alignment: Alignment.center, // Center overlay elements
        children: <Widget>[
          // The main camera view for scanning
          _buildQrView(context), 
          
          // Example of an overlay element: Displaying the scan result or prompt
          Positioned(
             bottom: 50, // Position it near the bottom
             child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.5),
                   borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                   result != null ? 'Scan successful!' : 'Scan QR code on bus',
                   style: const TextStyle(color: Colors.white),
                ),
             ),
          ),
          // Optional: Add buttons for flash toggle, camera flip etc.
        ],
      ),
    );
  }

  // 7. Build the QRView widget
  Widget _buildQrView(BuildContext context) {
    // Define the scanning area size
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0 // Smaller devices
        : 300.0; // Larger devices

    return QRView(
      key: qrKey, // Assign the key
      onQRViewCreated: _onQRViewCreated, // Callback when the view is ready
      // Customize the scanner overlay (the box and border)
      overlay: QrScannerOverlayShape( 
          borderColor: Colors.deepPurple,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea), // The size of the transparent scanning area
      // Callback for permission status
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p), 
    );
  }

  // 8. Callback function when the QRView is created and ready
  void _onQRViewCreated(QRViewController controller) {
    print("QR View Created!");
    setState(() {
      this.controller = controller; // Store the controller
    });

    // Listen to the stream of scanned data
    controller.scannedDataStream.listen((scanData) {
      // Check if we are already processing a scan and if the widget is still mounted (visible)
      if (!navigating && mounted) { 
        setState(() {
          result = scanData; // Store the scan result
          navigating = true; // Set flag to prevent multiple navigations
          controller.pauseCamera(); // Pause camera to stop further scanning
        });

        // IMPORTANT: Check if the scanned code is not null or empty
        if (result != null && result!.code != null && result!.code!.isNotEmpty) {
          print("QR Code Scanned: ${result!.code}"); // Log the code

          // Navigate to the Bus Confirmation page, replacing the scanner page
          Navigator.of(context).pushReplacement( 
            MaterialPageRoute(
              // Pass the scanned code to the next page
              builder: (context) => BusConfirmationPage(busId: result!.code!), 
            ),
          ).then((_) {
             // This part runs if we ever come back to this page (less likely with pushReplacement)
             // Reset the flag if the widget is still mounted
             if (mounted) { 
               setState(() {
                 navigating = false; 
               });
             }
          });
        } else {
          print("Scan resulted in null or empty data.");
          // Show feedback if scan failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not read QR code. Try again.')),
          );
          // Reset flag and resume camera if navigation didn't happen
          if (mounted) {
             setState(() {
               navigating = false; 
               controller.resumeCamera(); // Let the user try again
             });
          }
        }
      }
    });
     // Ensure camera starts if it was paused previously
     controller.resumeCamera();
  }

  // 9. Callback function for camera permission result
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('Permission Check: $p');
    // If permission is not granted, show a message
    if (!p) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required to scan QR codes.')),
      );
    }
  }

  // 10. Clean up the controller when the widget is removed from the screen
  @override
  void dispose() {
    controller?.dispose(); 
    super.dispose();
  }
}

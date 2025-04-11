import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift/pages/driverSection/journeyMapPage.dart'; // Import the map page

class BusConfirmationPage extends StatefulWidget {
  const BusConfirmationPage({Key? key, required this.busId}) : super(key: key);

  final String busId; // Received from QrScannerPage

  @override
  State<BusConfirmationPage> createState() => _BusConfirmationPageState();
}

class _BusConfirmationPageState extends State<BusConfirmationPage> {
  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State variables
  Map<String, dynamic>? _busData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isStartingJourney = false; // To show loading indicator on button

  @override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }

  // Function to fetch bus details from Firestore
  Future<void> _fetchBusDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Assuming 'VehiclesData' collection uses the scanned QR code (busId) as document ID
      DocumentSnapshot doc = await _firestore.collection('VehiclesData').doc(widget.busId).get();

      if (doc.exists) {
        setState(() {
          _busData = doc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
        // Optionally, send "Ready" status immediately after confirming bus
        // await _updateDriverStatus("Ready"); 
      } else {
        setState(() {
          _errorMessage = "Bus with ID ${widget.busId} not found.";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching bus details: $e");
      setState(() {
        _errorMessage = "Failed to fetch bus details. Please try again.";
        _isLoading = false;
      });
    }
  }

  // Function to update driver status and assigned bus
  Future<void> _updateDriverStatus(String status, {String? busId}) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      // Handle case where user is somehow not logged in
      print("Error: No authenticated user found.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error. Please log in again.')),
      );
      return;
    }

    // Assuming DriversData uses phone number as document ID (as seen in OTPauth)
    // If it uses UID, adjust accordingly: doc(currentUser.uid)
    final driverDocRef = _firestore.collection('DriversData').doc(currentUser.phoneNumber);

    Map<String, dynamic> updateData = {
      'status': status,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    if (busId != null) {
      updateData['currentBusId'] = busId; 
    } else {
       // If setting status back to 'Ready', maybe clear the bus ID
       updateData['currentBusId'] = FieldValue.delete(); // Or set to null
    }

    try {
      await driverDocRef.update(updateData);
      print("Driver status updated to: $status, Bus ID: $busId");
    } catch (e) {
      print("Error updating driver status: $e");
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status. Check connection.')),
      );
       throw e; // Re-throw to stop the process if needed
    }
  }

  // Function called when "Start Journey" is pressed
  Future<void> _startJourney() async {
     if (_busData == null || _auth.currentUser == null) return; // Safety check

     setState(() {
       _isStartingJourney = true; 
     });

     try {
       // Update driver status to 'On Journey' and assign bus ID
       await _updateDriverStatus("On Journey", busId: widget.busId);
       
       // Navigate to the map page
       if (mounted) { // Check if widget is still on screen
          Navigator.of(context).pushReplacement(
             MaterialPageRoute(
                // Pass necessary info (like busId, maybe route details later) to Map Page
                builder: (context) => JourneyMapPage(busId: widget.busId), 
             ),
          );
       }

     } catch (e) {
       // Error already handled in _updateDriverStatus, just stop loading indicator
       if (mounted) {
          setState(() {
             _isStartingJourney = false; 
          });
       }
     }
     // Don't set _isStartingJourney back to false here if navigation is successful
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Bus Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Allow going back to QR scanner if bus not found or wrong bus scanned
          onPressed: () => Navigator.of(context).pop(), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator() // Show loading spinner
              : _errorMessage != null
                  ? Column( // Show error message
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.error_outline, color: Colors.red, size: 50),
                         SizedBox(height: 10),
                         Text(_errorMessage!, textAlign: TextAlign.center),
                         SizedBox(height: 20),
                         ElevatedButton(
                             onPressed: _fetchBusDetails, // Allow retry
                             child: const Text('Retry'),
                         )
                      ], 
                    )
                  : _busData != null 
                      ? Column( // Show bus details and button
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Bus ID: ${widget.busId}', style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 20),
                            // Display other bus details fetched from Firestore
                            Text('Vehicle Number: ${_busData!['VehicleNumber'] ?? 'N/A'}'),
                            Text('Model: ${_busData!['Model'] ?? 'N/A'}'),
                            // Add more details as needed (Capacity, etc.)
                            const SizedBox(height: 40),
                            _isStartingJourney
                              ? const CircularProgressIndicator()
                              : ElevatedButton.icon(
                                   icon: const Icon(Icons.navigation_outlined),
                                   label: const Text('Start Journey'),
                                   onPressed: _startJourney,
                                   style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                   ),
                                ),
                          ],
                        )
                       : const Text("Something went wrong. Bus data is null."), // Fallback
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart'; // Added for distance calculation
import 'package:swift/pages/driverSection/journeyCompletePage.dart'; // Added for navigation

class JourneyMapPage extends StatefulWidget {
  final String busId;
  const JourneyMapPage({Key? key, required this.busId}) : super(key: key);

  @override
  State<JourneyMapPage> createState() => _JourneyMapPageState();
}

class _JourneyMapPageState extends State<JourneyMapPage> {
  // Map Controller, Location Service, Firebase Instances (same as before)
  final Completer<GoogleMapController> _controllerCompleter = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  final loc.Location _locationService = loc.Location();
  loc.LocationData? _currentLocation;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Map Elements (same as before)
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Route & Destination Data
  LatLng? _destinationCoordinates; // Added to store final stop location
  bool _isCompletingJourney = false; // Added for completion state management

  // Initial Camera Position, Loading State (same as before)
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 5);
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMapAndLocationAndRoute();
  }

  Future<void> _initializeMapAndLocationAndRoute() async { /* ... same as before ... */ 
     setState(() { _isLoading = true; _errorMessage = null; });
    try {
      // 1. Init Location
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) throw Exception('Location services are disabled.');
      }
      loc.PermissionStatus permissionGranted = await _locationService.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) throw Exception('Location permissions are denied.');
      }
      _currentLocation = await _locationService.getLocation();
      if (_currentLocation?.latitude == null || _currentLocation?.longitude == null) {
         throw Exception('Could not get initial location.');
      }

      // Get map controller ready
      _mapController = await _controllerCompleter.future;

      // 2. Fetch Route Data
      final routeData = await _fetchRouteData();
      if (routeData == null) throw Exception("Could not load route data.");

      // 3. Process Route Data (this now also extracts destination)
      _processRouteData(routeData);
      if (_destinationCoordinates == null) {
         print("Warning: Destination coordinates could not be determined from route data.");
      } 
      
      // 4. Move camera
      _fitRouteBounds(routeData);
      
      // 5. Update driver marker
      _updateDriverMarker(); 

      // 6. Start location updates & Firestore updates
      _startLocationUpdates();
      if (_currentLocation != null) {
        await _updateLocationInFirestore(_currentLocation!); 
      }

      setState(() { _isLoading = false; });
    } catch (e) {
      print("Error initializing map/location/route: $e");
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
    }
  }

  Future<Map<String, dynamic>?> _fetchRouteData() async { /* ... same as before ... */ }

  void _processRouteData(Map<String, dynamic> routeData) {
      _polylines.clear();
      _markers.removeWhere((m) => m.markerId.value != 'driverLocation');

      // Process Stops and identify destination
      if (routeData['stops'] is List) {
          final List stops = routeData['stops'];
          for (var i = 0; i < stops.length; i++) {
              final stop = stops[i];
              if (stop is Map && stop['location'] is GeoPoint && stop['name'] is String) {
                 final location = stop['location'] as GeoPoint;
                 final name = stop['name'] as String;
                 final latLng = LatLng(location.latitude, location.longitude);
                 _markers.add(
                     Marker(
                         markerId: MarkerId('stop_$i'),
                         position: latLng,
                         infoWindow: InfoWindow(title: name, snippet: "Stop ${i + 1}"),
                         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                     )
                 );
                 // Assume the last stop in the list is the destination
                 if (i == stops.length - 1) { 
                    _destinationCoordinates = latLng;
                    print("Destination set to: (${_destinationCoordinates!.latitude}, ${_destinationCoordinates!.longitude})");
                 }
              }
          }
      }

      // Process Polyline (same as before)
      if (routeData['polylinePoints'] is List) { /* ... */ }
      
      setState(() {}); 
  }

  void _fitRouteBounds(Map<String, dynamic> routeData) { /* ... same as before ... */ }
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) { /* ... same as before ... */ }
  Future<void> _moveCameraToCurrentLocation() async { /* ... same as before ... */ }
  void _updateDriverMarker() { /* ... same as before ... */ }
  Future<void> _updateLocationInFirestore(loc.LocationData locationData) async { /* ... same as before ... */ }

  // --- Destination Check Logic --- 

  void _checkIfDestinationReached(loc.LocationData currentLocation) {
    if (_destinationCoordinates == null || _isCompletingJourney || currentLocation.latitude == null || currentLocation.longitude == null) {
      // Cannot check if destination isn't set, already completing, or current location is invalid
      return;
    }

    // Define the arrival threshold (e.g., 50 meters)
    const double arrivalThresholdMeters = 50.0; 

    // Calculate distance using Geolocator
    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude!,
      currentLocation.longitude!,
      _destinationCoordinates!.latitude,
      _destinationCoordinates!.longitude,
    );

    print("Distance to destination: $distanceInMeters meters");

    if (distanceInMeters <= arrivalThresholdMeters) {
      print("Destination reached!");
      _completeJourney();
    }
  }

  Future<void> _completeJourney() async {
    // Prevent multiple executions
    if (_isCompletingJourney) return;
    setState(() {
      _isCompletingJourney = true;
    });

    // Stop listening to location updates
    _locationSubscription?.cancel();
    print("Location updates stopped.");

    // Update driver status in Firestore
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final driverDocRef = _firestore.collection('DriversData').doc(currentUser.phoneNumber);
      try {
        await driverDocRef.update({
          'status': 'Ready', // Or 'Available' or similar idle status
          'currentBusId': FieldValue.delete(), // Remove assigned bus
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print("Driver status updated to Ready, bus unassigned.");
      } catch (e) {
        print("Error updating driver status on journey completion: $e");
        // Decide if we should still navigate or show an error
      }
    }

    // Navigate to Journey Complete page
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const JourneyCompletePage()),
      );
    } 
  }

  // --- End Destination Check Logic ---

  void _startLocationUpdates() {
    _locationSubscription = _locationService.onLocationChanged
        .listen((loc.LocationData result) {
      if (mounted && !_isCompletingJourney) { // Also check if not already completing
        _currentLocation = result;
        _updateDriverMarker();
        _updateLocationInFirestore(result);

        // Check distance to destination on each update
        _checkIfDestinationReached(result); 
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { /* ... build method largely same as before ... */ 
     // Potentially add a loading overlay if _isCompletingJourney is true
     return Scaffold(
      appBar: AppBar(
        title: Text('Journey - Bus ${widget.busId}'),
      ),
      body: Stack( // Use Stack to potentially overlay loading indicator
         children: [ 
            _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(/* error display */)
                  : GoogleMap( /* map config */ ),
            if (_isCompletingJourney)
               Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         CircularProgressIndicator(color: Colors.white),
                         SizedBox(height: 15),
                         Text("Completing Journey...", style: TextStyle(color: Colors.white, fontSize: 16)),
                       ],
                     ),
                  ),
               )
         ] 
      ),
      floatingActionButton: /* ... same as before ... */
    );
  }
}


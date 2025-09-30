import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

// Function to show the minimalist dialog
void showMinimalistDeveloperFootprintDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Developer Footprint',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Developer Name
            const Text(
              'Developed by Md Siamul Islam Soaib',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54, // Lighter text color
              ),
            ),
            const SizedBox(height: 5),


            // Optionally add a website link
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://github.com/mdsiamulislam/'); // Replace with your website
                if (!await launchUrl(url)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch website.')),
                  );
                }
              },
              child: const Text(
                'Here I am', // Text to display for the link
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.blue, // Use the same accent color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Helper function for encoding query parameters for mailto links
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
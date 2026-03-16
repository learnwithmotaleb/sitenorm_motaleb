import 'package:flutter/material.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("Reference"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            '''© 2026 Dominion Land Resources LLC. All rights reserved.

SiteNorm™ is a product of Dominion Land Resources LLC.
Unauthorized reproduction, distribution, or use of the SiteNorm platform, methodology, or website content is prohibited.

Data sources include publicly available climate datasets.

All content, software, algorithms, and analysis provided through SiteNorm are the intellectual property of Dominion Land Resources LLC and may not be copied, reproduced, or distributed without permission.''',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
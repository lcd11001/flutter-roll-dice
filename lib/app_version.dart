// Generate AppVersion class to get app version using package_info_plus
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatelessWidget {
  final Widget Function(BuildContext, PackageInfo) builder;

  const AppVersion({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return builder(context, snapshot.data as PackageInfo);
          }
        }
        return const SizedBox();
      },
    );
  }
}

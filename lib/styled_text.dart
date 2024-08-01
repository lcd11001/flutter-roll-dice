import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatefulWidget {
  final String text;

  const StyledText(this.text, {super.key});

  @override
  State<StyledText> createState() => _StyledTextState();
}

class _StyledTextState extends State<StyledText> {
  late final Future googleFontsPending;

  @override
  void initState() {
    super.initState();
    googleFontsPending = GoogleFonts.pendingFonts([
      GoogleFonts.pacifico(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: googleFontsPending,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }

        return Text(
          widget.text,
          style: GoogleFonts.getFont("Pacifico").copyWith(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

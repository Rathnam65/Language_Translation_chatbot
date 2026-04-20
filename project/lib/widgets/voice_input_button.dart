import 'package:flutter/material.dart';

class VoiceInputButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const VoiceInputButton({
    super.key,
    required this.isListening,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isListening
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none,
          color: isListening
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
    );
  }
}
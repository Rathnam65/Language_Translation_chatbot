import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_chatbot/providers/language_provider.dart';

class LanguageSwapButton extends StatefulWidget {
  const LanguageSwapButton({super.key});

  @override
  State<LanguageSwapButton> createState() => _LanguageSwapButtonState();
}

class _LanguageSwapButtonState extends State<LanguageSwapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    // If source is auto-detect, we shouldn't swap
    if (languageProvider.sourceLanguage?.code == 'auto') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot swap when source language is set to auto-detect'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Play the animation
    _controller.reset();
    _controller.forward();
    
    // Swap languages
    languageProvider.swapLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              onPressed: _swapLanguages,
              tooltip: 'Swap languages',
            ),
          ),
        );
      },
    );
  }
}
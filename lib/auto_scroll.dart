import 'package:flutter/material.dart';

class AutoScrollingText extends StatefulWidget {
  @override
  _AutoScrollingTextState createState() => _AutoScrollingTextState();
}

class _AutoScrollingTextState extends State<AutoScrollingText> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _scrollText();
  }

  void _scrollText() {
    if (_scrollController.hasClients && _scrollPosition < _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollPosition + 1.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      _scrollPosition += 0.1; // Increment by a smaller value for smoother scrolling
      Future.delayed(Duration(milliseconds: 300), _scrollText);
    } else {
      _scrollPosition = 0.0;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      _startAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Text(
        'This is an example of auto-scrolling text. ',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

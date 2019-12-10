import 'package:flutter/material.dart';

class MapStickLocFab extends StatefulWidget {
  final Function() onTap;
  final MapStickLocFabController controller;
  final double startLocation;
  final double panelHeightOpen;
  final double panelHeightClose;

  const MapStickLocFab({
    Key key,
    this.onTap,
    this.startLocation = 100,
    this.panelHeightOpen,
    this.panelHeightClose,
    this.controller,
  }) : super(key: key);

  @override
  _MapStickLocFabState createState() => _MapStickLocFabState();
}

class _MapStickLocFabState extends State<MapStickLocFab> {
  double pos = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.callback = (double pos) {
      this.setState(() {
        this.pos = pos;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: pos * (widget.panelHeightOpen - widget.panelHeightClose) +
          widget.startLocation,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: FloatingActionButton(
          mini: true,
          child: Icon(Icons.my_location),
          onPressed: widget.onTap,
        ),
      ),
    );
  }
}

class MapStickLocFabController {
  void Function(double) callback;
}

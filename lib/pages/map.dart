import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/components/commentAdd.dart';
import 'package:safe/components/components.dart';
import 'package:safe/components/mapStickLocFab.dart';
import 'package:safe/main.dart';
import 'package:safe/style/colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapBloc _mapBloc;

  GoogleMapController _mapController;
  PanelController _panelController = PanelController();
  final MapStickLocFabController _fabController = MapStickLocFabController();

  final double _panelHeightOpen = 500;
  final double _panelHeightClosed = 100;

  @override
  void initState() {
    super.initState();
    _mapBloc = MapBloc();
    try {
      Location().getLocation().then((locData) {
        SafeApp.lastLocation = LatLng(locData.latitude, locData.longitude);
      });
    } catch (e) {
      print("Location not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapEvent, MapState>(
      bloc: _mapBloc,
      listener: (context, state) {
        if (state is MapItemSelected) {
          _panelController.open();
          _mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: state.selected.location,
              zoom: 12,
            ),
          ));
        }
      },
      child: BlocProvider(
        bloc: _mapBloc,
        child: Stack(
          children: [
            SlidingUpPanel(
              controller: _panelController,
              color: SafeColors.charcoal,
              minHeight: _panelHeightClosed,
              maxHeight: _panelHeightOpen,
              parallaxEnabled: true,
              parallaxOffset: .6,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              onPanelSlide: (val) => _fabController.callback(val),
              panel: MapPanel(),
              body: BlocBuilder<MapEvent, MapState>(
                bloc: _mapBloc,
                builder: (context, state) => GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: state.eventsToMarkers((event) {
                    _mapBloc.dispatch(MapSelect(event.id));
                  }),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    controller.setMapStyle(SafeApp.mapStyle);
                  },
                  onTap: (location) {
                    if (state is MapItemSelected) {
                      _panelController.close();
                      _mapBloc.dispatch(MapUnSelect());
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: SafeApp.lastLocation,
                    zoom: 12,
                  ),
                ),
              ),
            ),
            BlocBuilder<MapEvent, MapState>(
              bloc: _mapBloc,
              builder: (context, state) {
                if (state is MapItemSelected)
                  return SafeArea(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _mapBloc.dispatch(MapUnSelect()),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CommentAddWidget(),
                        )
                      ],
                    ),
                  );
                return Container();
              },
            ),
            MapStickLocFab(
              panelHeightClose: _panelHeightClosed,
              panelHeightOpen: _panelHeightOpen,
              startLocation: _panelHeightClosed,
              controller: _fabController,
              onTap: () {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: SafeApp.lastLocation,
                    zoom: 15,
                  ),
                ));
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapBloc.dispose();
    super.dispose();
  }
}

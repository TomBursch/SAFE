import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe/bloc/bloc.dart';
import 'package:safe/main.dart';
import 'package:safe/style/colors.dart';
import 'package:location/location.dart';

class CreateNewPage extends StatefulWidget {
  @override
  _CreateNewPageState createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  CreateBloc _createBloc;
  TextEditingController _nameController = TextEditingController();
  GoogleMapController _mapController;
  CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();

    _createBloc = CreateBloc();

    try {
      Location().getLocation().then((locData) {
        SafeApp.lastLocation = LatLng(locData.latitude, locData.longitude);
        if (_mapController != null)
          _cameraPosition = CameraPosition(
            target: SafeApp.lastLocation,
            zoom: 15,
          );
        _mapController
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      });
    } catch (e) {
      print("Location not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateEvent, CreateState>(
      bloc: _createBloc,
      listener: (context, state) {
        if (state is CreateSuccess) {
          _nameController.text = "";
          BlocProvider.of<HomeBloc>(context).dispatch(HomeEvent(0));
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Be descriptive",
                  hasFloatingPlaceholder: false,
                ),
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(FocusNode()),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: SafeColors.portlandOrange,
                      width: 2,
                    ),
                  ),
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        GoogleMap(
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          onCameraMove: (cPos) {
                            _cameraPosition = cPos;
                          },
                          onMapCreated: (GoogleMapController controller) {
                            controller.setMapStyle(SafeApp.mapStyle);
                            _mapController = controller;
                            _cameraPosition = CameraPosition(
                              target: SafeApp.lastLocation,
                              zoom: 15,
                            );
                            _mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    _cameraPosition));
                          },
                          initialCameraPosition: CameraPosition(
                            target: SafeApp.lastLocation,
                            zoom: 3,
                          ),
                        ),
                        Transform.translate(
                            offset: Offset(0, -10),
                            child: Icon(
                              Icons.location_on,
                              color: SafeColors.portlandOrange,
                            )),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: FloatingActionButton(
                              mini: true,
                              child: Icon(Icons.my_location),
                              onPressed: () {
                                _mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: SafeApp.lastLocation,
                                    zoom: 15,
                                  ),
                                ));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              RaisedButton(
                  child: Text("Create"),
                  onPressed: () => _createBloc.dispatch(CreateEvent(
                        name: _nameController.text,
                        location: _cameraPosition.target,
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _createBloc.dispose();
    super.dispose();
  }
}

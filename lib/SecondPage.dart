import 'package:demo1/Location Fetcher.dart';
import 'package:demo1/ThirdPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'variables.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GetLocation gl= GetLocation();
  List<TextEditingController> _editingControllerList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    k=0;
  }
  Future<void> myLocation()async
  {
    Position l1= await gl.determinePosition();
    locationStorage.putIfAbsent(l1.latitude.toDouble(), () => l1.longitude.toDouble());
    print(locationStorage.entries);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (int i = 0; i < NoOfPeople-1; i++) {
      _editingControllerList[editingControllerCounter].dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: _key,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: NoOfPeople-1,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  "Enter latitude and longitude of person no ${index + 1}",
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                            onSaved: (value) {
                              print(value);
                              var z= value.toString().split(' ').first;
                              var y= value.toString().split(' ').last;
                              locationStorage.putIfAbsent(double.parse(z), () => double.parse(y));
                             // locationAdder();
                            },
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                    onPressed: ()async{
                       await myLocation();
                       _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Location Fetched"),
                       duration: Duration(seconds: 2),
                       ));
                    },
                    child: Text("Get My Location")),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:30.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      if(k==0)
                        {
                          if(latsum!=finalLatSum && longsum!=finalLongSum)
                          {
                            getCentroid();
                          }
                        }
                      else
                        {
                          updateLatLong();
                        }
                      k++;
                   // meetPoint= MeetUpPage();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPages()));

                    }
                  },
                  child: Text("Save and Next")),
            ),
          ],
        ),
      ),
    );
  }
}

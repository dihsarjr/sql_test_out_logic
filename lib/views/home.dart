import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sql_app/model/employee_model.dart';
import 'package:sql_app/providers/data_base_provider.dart';
import 'package:sql_app/providers/employee_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variables
  bool load = false;

  @override
  void initState() {
    DBProvider.db.database.then((value) {
      DBProvider.db.getTodo().then((value) {
        if (value != null && value.length >= 1) {
          setState(() {
            load = true;
          });
        } else {
          Provider.of<EmployeeProvider>(context, listen: false)
              .getTodo()
              .then((value) {
            if (value != null) {
              DBProvider.db.getTodo().then((value) {
                setState(() {
                  load = true;
                });
              });
            }
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Sql"),
        centerTitle: true,
      ),
      body: load == false
          ? Center(
              child: SpinKitRipple(
                color: Colors.red,
              ),
            )
          : FutureBuilder<List<TodoModel>>(
              future: DBProvider.db.getTodo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          title: Text("${snapshot.data[i].title}"),
                          leading: Icon(Icons.person_rounded),
                          subtitle:
                              Text("Completed : ${snapshot.data[i].completed}"),
                        );
                      },
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                    );
                  } else {
                    return Center(
                      child: Text("No Data Available"),
                    );
                  }
                } else {
                  return Center(
                    child: SpinKitRipple(
                      color: Colors.red,
                    ),
                  );
                }
              }),
    );
  }
}

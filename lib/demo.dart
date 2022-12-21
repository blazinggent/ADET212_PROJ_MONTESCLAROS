import 'package:flutter/material.dart';
import 'add_violator_details.dart';
import 'violator.dart';
import 'db_helper.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid Protocol Violators'),
      ),
      body: FutureBuilder<List<Violator>>(
        future: DBHelper.readViolator(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Violator>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading...'),
                ],
              ),
            );
          }
          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text('No Violators'),
                )
              : ListView(
                  children: snapshot.data!.map((violator) {
                    return Center(
                      child: ListTile(
                        title: Text(violator.name!),
                        subtitle: Text('${violator.mobileNumber}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.deleteViolator(violator.id!);
                            setState(() {});
                          },
                        ),
                        onTap: () async {
                          final refresh = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => AddViolatorDetails(
                                        details: Violator(
                                          id: violator.id,
                                          name: violator.name,
                                          mobileNumber: violator.mobileNumber,
                                        ),
                                      )));

                          if (refresh) {
                            setState(() {});
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final refresh = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddViolatorDetails()));

          if (refresh) {
            setState(() {});
          }
        },
      ),
    );
  }
}

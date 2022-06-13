import 'package:flutter/material.dart';
import 'package:sqflite_tutorial/db/data_base.dart';
import 'package:sqflite_tutorial/model/grocery.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SqliteApp());
  }
}

class SqliteApp extends StatefulWidget {
  SqliteApp({Key? key}) : super(key: key);

  @override
  State<SqliteApp> createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Grocery>>(
            future: DatabaseHelper.instance.getGroceries(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("Loading..."),
                );
              }
              return snapshot.data!.isEmpty
                  ? Center(
                      child: Text("No Groceries in List."),
                    )
                  : ListView(
                      children: snapshot.data!.map((grocery) {
                        return Center(
                          child: Card(
                            color: selectedId == grocery.id
                                ? Colors.white70
                                : Colors.white,
                            child: ListTile(
                              title: Text(grocery.name),
                              onTap: () {
                                setState(() {
                                  if (selectedId == null) {
                                    textController.text = grocery.name;
                                    selectedId = grocery.id;
                                  } else {
                                    textController.text = "";
                                    selectedId = null;
                                  }
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  DatabaseHelper.instance.remove(grocery.id!);
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance
                  .update(Grocery(id: selectedId, name: textController.text))
              : await DatabaseHelper.instance
                  .add(Grocery(name: textController.text));

          setState(() {
            textController.clear();
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

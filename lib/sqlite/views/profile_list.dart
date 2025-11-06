import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/models/influencer.dart';
import 'package:ppbl/sqlite/views/profile_edit.dart';
import '../services/sqlite_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo Transaksi SQLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();

    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  void addData() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditPage(influencer: Influencer(nickName: '')))).then((_) {
      setState(() {});
    });
  }

  void editData(Influencer influencer) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(influencer: influencer))).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [IconButton(onPressed: addData, icon: const Icon(Icons.add))],
      ),
      body: FutureBuilder(
        future: handler.retrieveInfluencers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Influencer>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  child: Column(
                    children: <Widget>[
                      Card(
                          child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(snapshot.data![index].nickName),
                        subtitle: Text(snapshot.data![index].realName ?? ''),
                        onTap: () => editData(snapshot.data![index]),
                      )),
                    ],
                  ),
                  onDismissed: (DismissDirection direction) async {
                    print("Kunci yang dihapus: ${snapshot.data![index].id}");
                    await handler.deleteInfluencer(snapshot.data![index].id);
                    snapshot.data?.removeAt(index);
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

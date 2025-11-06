import 'package:flutter/material.dart';
import 'package:ppbl/models/playlist.dart';
import 'package:ppbl/models/preferensi.dart';
import 'package:provider/provider.dart';
import 'package:ppbl/notifier/LaguSaatIni.dart';
import 'package:ppbl/notifier/PlayerControl.dart';

const List<Widget> icons = <Widget>[
  Icon(Icons.shuffle),
  Icon(Icons.repeat),
];

class FitPlayer extends StatelessWidget {
  const FitPlayer({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Pemutar Lagu FIT')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Consumer<LaguSaatIniModel>(
              builder: (context, lagu, child) => Image.asset(
                '${lagu.saatIni.imagePath}',
                height: 400,
                width: 400,
                alignment: Alignment.center,
              )
          ),

          Consumer<LaguSaatIniModel>(
            builder: (context, lagu, child) =>
                Padding(
                  padding: EdgeInsets.only(bottom: 40, top:10), //apply padding to some sides only
                  child: Text(
                    '${lagu.saatIni.judul}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 45,
                icon: const Icon(Icons.repeat),
                onPressed: () {
                  var repeatState = context.read<PlayerControl>();
                  bool? repeatValue = repeatState.isRandom;
                  if(repeatValue == false)
                    repeatState.setRandom(true);
                  else
                    repeatState.setRandom(false);

                  final repeatSnack = SnackBar(
                    content: Consumer<PlayerControl>(
                      builder: (BuildContext context, PlayerControl value, Widget? child) {
                        return Text('${value.isRandom == true ? "Playlist Berulang" : "Playlist tidak berulang"}');
                      },),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(repeatSnack);
                },
              ),
              IconButton(
                iconSize: 62,
                icon: const Icon(Icons.shuffle),
                onPressed: () {
                  var shuffleState = context.read<PlayerControl>();
                  bool? shuffleValue = shuffleState.isShuffle;
                  if(shuffleValue == false)
                    shuffleState.setRandom(true);
                  else
                    shuffleState.setRandom(false);

                  final shuffleSnack = SnackBar(
                    content: Consumer<PlayerControl>(
                      builder: (BuildContext context, PlayerControl value, Widget? child) {
                        return Text('${value.isRandom == true ? "Main secara acak" : "Main secara berurutan"}');
                      },),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(shuffleSnack);

                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.

                },
              ),

            ],
          ),
          Expanded(child: Container()),
          Row(
            children: [],
          ),
          ListView.builder(
              itemCount: PlaylistModel.daftarLagu.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                    margin: EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: ListTile(
                      title: Text("${PlaylistModel.daftarLagu[index].judul} (${PlaylistModel.daftarLagu[index].artis})"),
                      onTap: () {
                        var laguSaatIni = context.read<LaguSaatIniModel>();
                        laguSaatIni.saatIni = PlaylistModel.daftarLagu[index];
                      },
                    )
                );
              })
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
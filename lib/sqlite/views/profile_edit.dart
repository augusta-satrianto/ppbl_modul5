import 'package:flutter/material.dart';
import 'package:ppbl/sqlite/models/social_media.dart';
import 'package:ppbl/sqlite/services/sqlite_service.dart';
import '../models/influencer.dart';

class EditPage extends StatefulWidget {
  final Influencer influencer;
  const EditPage({super.key, required this.influencer});

  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String? _selectedSocial;
  final nicknameController = TextEditingController();
  final realnameController = TextEditingController();
  final accountNameController = TextEditingController();
  late DatabaseHandler db;

  @override
  void initState() {
    super.initState();

    this.db = DatabaseHandler();
    this.db.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.influencer.id == null
            ? 'Tambah influencer'
            : 'Edit influencer'),
        actions: [IconButton(onPressed: addSocialChannel, icon: const Icon(Icons.add))],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
              child: TextFormField(
                controller: nicknameController
                  ..text = widget.influencer.nickName,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
                decoration: const InputDecoration(hintText: 'Nama beken'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: TextFormField(
                controller: realnameController
                  ..text = widget.influencer.realName ?? '',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
                decoration: const InputDecoration(hintText: 'Nama asli'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24.0, 0, 18.0),
              child: Text('Kanal media sosial'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12),
                  itemCount: widget.influencer.socialMedia.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // call the associated function for this item
                        showSocialMediaDialog(
                            widget.influencer.socialMedia[index], context);
                      },
                      child: Container(
                        color: Colors.blue, // color of grid items
                        child: Center(
                          child: Text(
                            '${widget.influencer.socialMedia[index].network}: ${widget.influencer.socialMedia[index].account}', // display text for this item
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () async {
                  await saveInfluencer();
                  closeWidget(context);
                  },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nicknameController.dispose();
    realnameController.dispose();
    accountNameController.dispose();
    super.dispose();
  }

  Future<void> saveInfluencer() async {
      widget.influencer.nickName = nicknameController.text;
      widget.influencer.realName = realnameController.text;

      if (widget.influencer.id == null) {
        await db.insertInfluencer([widget.influencer]);
      } else {
        await db.updateInfluencer(widget.influencer);
      }
  }

  void showSocialMediaDialog(SocialMedia? social, BuildContext context) {
    _selectedSocial = social?.network ?? 'instagram';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit media sosial'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    value: _selectedSocial,
                    items: const [
                      DropdownMenuItem(
                        value: 'instagram',
                        child: Text('Instagram'),
                      ),
                      DropdownMenuItem(
                        value: 'tiktok',
                        child: Text('Tiktok'),
                      ),
                      DropdownMenuItem(
                        value: 'x',
                        child: Text('X'),
                      ),
                      DropdownMenuItem(
                        value: 'youtube',
                        child: Text('YouTube'),
                      ),
                    ],
                    onChanged: (String? newVal) {
                      setState(() {
                        _selectedSocial = newVal!;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                    child: TextFormField(
                      controller: accountNameController
                        ..text = social?.account ?? '',
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(hintText: 'Akun kanal'),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                saveSocialChannel(social);
                closeWidget(context);
              },
            ),
          ],
        );
      },
    );
  }

  void addSocialChannel() {
    showSocialMediaDialog(null, context);
  }

  void saveSocialChannel(SocialMedia? social) {
    if (social == null) {
      social = SocialMedia(
          network: _selectedSocial!,
          account: accountNameController.text,
          influencerId: widget.influencer.id ?? 0);
      widget.influencer.socialMedia.add(social!);
    } else {
      social!.network = _selectedSocial!;
      social!.account = accountNameController.text;
    }


  }

  void closeWidget(BuildContext context) {
    Navigator.pop(context);
    setState(() {});
  }
}

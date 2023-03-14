import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes/boxes.dart';
import 'package:flutter_hive/models/notes_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (Context, box, child) {
                  final isDark = box.get('isDark', defaultValue: false);
                  return Switch(
                      value: isDark,
                      onChanged: (val) {
                        box.put('isDark', val);
                      });
                }),
          ],
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ClipOval(
              child: Image(
                image: Image.asset('lib/assets/icon.png').image,
              ),
            ),
          ),
          backgroundColor: Color(0xff8BC34A),
          centerTitle: true,
          title: const Text('Keep Notes'),
        ),
        body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  // reverse: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),

                      // color: Color(0xffFCE4EC),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(data[index].title.toString()),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    delete(data[index]);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                    onTap: () {
                                      _editDialog(
                                          data[index],
                                          data[index].title.toString(),
                                          data[index].description.toString());
                                    },
                                    child: Icon(Icons.edit)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data[index].description.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Icon(Icons.add),
          onPressed: () async {
            _showMyDialog();
          },
          backgroundColor: Color(0xff8BC34A),
        ),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        //      errorText:
                        // snapshot.error == null ? null : snapshot.error.toString()),
                        label: Text('Enter Title'),
                        hintText: 'Enter title',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        label: Text('Enter Description'),
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    notesModel.title = titleController.text.toString();
                    notesModel.description =
                        descriptionController.text.toString();
                    notesModel.save();
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('EDIT')),
            ],
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        label: Text('Enter Title'),
                        hintText: 'Enter title',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        label: Text('Enter Description'),
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    data.save();
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('ADD')),
            ],
          );
        });
  }
}

//! This is first practice for the hive database usage in flutter
//children to show the box data on home screen
/*FutureBuilder(
              future: Hive.openBox('mohsin'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data!.get('name').toString()),
                      subtitle: Text(snapshot.data!.get('age').toString()),
                    ),
                  ],
                );
              }),
          FutureBuilder(
              future: Hive.openBox('name'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data!.get('youtube').toString()),
                      subtitle: Text(snapshot.data!.get('youtube').toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          snapshot.data!.delete(
                            'youtube',
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                );
              }),*/

//box one
// var box = await Hive.openBox('mohsin');
// //bcx two
// var box2 = await Hive.openBox('name');
// //data in box two
// box2.put('youtube', 'coders');
// //data in box one
// box.put('details', {'pro': 'developer', 'work': 'office based'});
// box.put('name', 'mohsin');
// box.put('age', 22);

// print(box.get('name'));
// // print(box2.get('name'));
// print(box.get('age'));
// print(box.get('details'));

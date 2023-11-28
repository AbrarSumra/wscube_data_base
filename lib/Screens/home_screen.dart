// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_data_base/model/note_model.dart';

import '../AppData/app_data.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  late AppDataBase appData;
  List<NoteModel> data = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appData = AppDataBase.instance;
    getUserName();
    getAllNotes();
  }

  void getAllNotes() async {
    data = await appData.fetchNotes();
    setState(() {});
  }

  void getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString(LoginScreen.USERNAME_PREF_KEY);
    name = username!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              prefs.setBool(LoginScreen.LOGIN_PREF_KEY, false);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          var notes = data[index];
          return ListTile(
            title: Text(notes.note_title),
            subtitle: Text(notes.note_desc),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              name == "" ? "" : name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 21),
                    const Text(
                      "Add your note",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        label: const Text("Enter your Title"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    TextFormField(
                      controller: descController,
                      decoration: InputDecoration(
                        label: const Text("Enter your Description"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            var title = titleController.text.toString();
                            var desc = descController.text.toString();

                            appData.addNote(
                              NoteModel(
                                notex_id: 0,
                                note_title: title,
                                note_desc: desc,
                              ),
                            );
                            titleController.clear();
                            descController.clear();
                            getAllNotes();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

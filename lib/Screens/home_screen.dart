// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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
  bool isLike = false;
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
            icon: const Icon(EvaIcons.log_out),
          ),
        ],
      ),
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) {
                var notes = data[index];
                return InkWell(
                  onLongPress: () {
                    /// EDIT NOTE
                    openBottomSheet(
                      isUpdate: true,
                      noteId: notes.note_id,
                      noteTitle: notes.note_title,
                      noteDesc: notes.note_desc,
                    );
                  },
                  child: ListTile(
                    title: Text(
                      notes.note_title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(notes.note_desc),
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[index],
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isLike = !isLike;
                              });
                            },
                            icon: Icon(
                              isLike ? EvaIcons.heart : EvaIcons.heart_outline,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete?"),
                                    content: const Text(
                                        "are you sure want to delete ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          /// DELETE NOTES
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: SizedBox(
                                                height: 30,
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                        "Note deleted..."),
                                                    const Spacer(),
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: const Text(
                                                        "Undo",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                          appData.deleteNote(notes.note_id);
                                          getAllNotes();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Yes"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No Notes Added"),
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
          openBottomSheet();
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  void openBottomSheet({
    bool isUpdate = false,
    int noteId = 0,
    String noteTitle = "",
    String noteDesc = "",
  }) {
    titleController.text = noteTitle;
    descController.text = noteDesc;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 21),
              Text(
                isUpdate ? "Update your Note" : "Add Your Note",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 21),
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
                      if (titleController.text.isNotEmpty &&
                          descController.text.isNotEmpty) {
                        if (isUpdate) {
                          /// UPDATE NOTES
                          appData.updateNote(
                            NoteModel(
                              user_id: 1,
                              note_id: noteId,
                              note_title: titleController.text.toString(),
                              note_desc: descController.text.toString(),
                            ),
                          );
                        } else {
                          /// ADD NOTES
                          appData.addNote(
                            NoteModel(
                              user_id: 1,
                              note_id: 0,
                              note_title: titleController.text.toString(),
                              note_desc: descController.text.toString(),
                            ),
                          );
                        }
                      }
                      getAllNotes();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      isUpdate ? "Update" : "Add",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppData/app_data.dart';
import 'loginscreen.dart';

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
  List<Map<String, dynamic>> data = [];

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
          return ListTile(
            title: Text(data[index]["title"]),
            subtitle: Text(data[index]["desc"]),
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
                    const SizedBox(height: 11),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter your Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    TextFormField(
                      controller: descController,
                      decoration: InputDecoration(
                        hintText: "Enter your Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    ElevatedButton(
                      onPressed: () {
                        appData.addNote(
                          titleController.text.toString(),
                          descController.text.toString(),
                        );
                        getAllNotes();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add"),
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

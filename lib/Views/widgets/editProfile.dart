import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users_app_cracon/Controller/global/global.dart';
import 'package:users_app_cracon/constants.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (fAuth.currentUser != null) {
        String uid = fAuth.currentUser!.uid;
        fbase.child('users').child(uid).once().then((DatabaseEvent snapshot) {
          if (snapshot.snapshot.value != null) {
            print("Data:${snapshot.snapshot.value}");
            Map<dynamic, dynamic> values =
                snapshot.snapshot.value as Map<dynamic, dynamic>;
            setState(() {
              nameController.text = values['name'];
              emailController.text = values['email'];
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: [
          editableField('Name', nameController),
          editableField('Email', emailController),
          (isLoading)
              ? Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    strokeCap: StrokeCap.round,
                    color: primary,
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    if (fAuth.currentUser != null) {
                      String uid = fAuth.currentUser!.uid;
                      fbase.child('users').child(uid).update({
                        'name': nameController.text,
                        'email': emailController.text,
                      }).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile Updated Successfully'),
                          ),
                        );
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Update Profile'),
                ),
        ],
      ),
    );
  }
}

Widget editableField(String label, TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter $label',
            ),
          ),
        ),
      ],
    ),
  );
}

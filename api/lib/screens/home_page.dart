import 'package:api/bloc/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bloc/app_events.dart';
import '../bloc/app_blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();


  Future<void> _create() async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? price =
                    double.tryParse(_priceController.text);
                    if (price != null) {
                      _postData(context);

                      _nameController.text = '';
                      _nameController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );

        });
  }
  void _postData(context) {


    BlocProvider.of<ProductBloc>(context).add(
      Create(_nameController.text, _priceController.text),

    );



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Firebase Firestore')),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
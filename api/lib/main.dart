import 'package:api/repo/product_repo.dart';
import 'package:api/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'bloc/app_blocs.dart';
import 'bloc/app_states.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,

        home:  RepositoryProvider(
          create: (context) => ProductRepository(),
          child: const Home(),
        )
    );
  }
}
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    return BlocProvider(
      create: (context) => ProductBloc(
          productRepository:RepositoryProvider.of<ProductRepository>(context)
      ),
      child: Scaffold(
          key: scaffoldKey,
          body: BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductAdded) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Product added"), duration: Duration(seconds: 2),));
                }
              },
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductAdding) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(state is ProductError){
                    return const Center(child:Text("Error"));
                  }
                  return const HomePage();
                },
              )
          )
      ),
    );
  }
}
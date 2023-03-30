import 'package:blocs/models/user_model.dart';
import 'package:blocs/repos/repositories.dart';
import 'package:blocs/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_blocs.dart';
import 'blocs/app_events.dart';
import 'blocs/app_states.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:  false,

      home: RepositoryProvider(
        create: (context)=>UserRespository(),
        child: const Home(),
      ),

    );
  }
}
class Home extends StatelessWidget{
  const Home({Key? key}): super(key:key);
  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context)=>UserBloc(
      RepositoryProvider.of<UserRespository>(context),
    )..add(LoadUserEvent()),
    child: Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.teal,
    title: const Text('The Bloc App'),),
      body: BlocBuilder<UserBloc,UserState>(
        builder: (context,state){
          if(state  is UserLoadingState){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is UserLoadedState){
            List<UserModel> userList= state.users;
            return  ListView.builder(
              itemCount: userList.length,
              itemBuilder: (_,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> DetailScreen(
                          e:userList[index]
                        ))
                      );
                    },
                    child: Card(
                      color: Colors.blueGrey,
                      elevation: 4,
                      margin:  const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(userList[index].firstname,style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, color: Colors.white
                        ),),
                        subtitle: Text(userList[index].lastname,style :const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,color: Colors.white
                        )),
                        trailing:  CircleAvatar(
                          backgroundImage: NetworkImage(userList[index].avatar),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if(state is UserErrorState){
            return Center(child: Text("Error"),);
          }
          return Container();
        },
      ),
    ),
    );
  }
}

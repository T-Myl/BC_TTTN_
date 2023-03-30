import '../repos/repositories.dart';
import 'app_states.dart';
import 'app_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class UserBloc extends Bloc<UserEvent,UserState>{
  final UserRespository _userRespository;
  UserBloc(this._userRespository): super(UserLoadingState()){
    on<LoadUserEvent>((event,emit) async{
      emit(UserLoadingState());
      try{
        final  users =await _userRespository.getUsers();
        emit(UserLoadedState(users));
      }catch (e){
        emit(UserErrorState(e.toString()));

      }
    });
  }
}
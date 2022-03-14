import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/network/local/cache_helper.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeStates> {

  ThemeCubit() : super(AppInitialThemeState());

  static ThemeCubit get(context) => BlocProvider.of(context);


  bool isDark = true;

  void changeAppMode({bool? fromShared = true}){
    if (fromShared!= null)
    {
      isDark = fromShared;
    }
    else {
      isDark = !isDark;
    }
    CacheHelper.putBool(key: 'isDark', value: isDark).then((value)
    {
      emit(AppChangeModeStates());
    });
  }
}
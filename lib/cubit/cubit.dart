import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/states.dart';
import 'package:news_app/modules/busisness/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/network/local/cache_helper.dart';
import 'package:news_app/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{

  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business_center_outlined),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports_rounded),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science_outlined),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(index)
  {
    currentIndex = index;
    if (index == 1) getSports();
    if (index == 2) getScience();
    emit(NewsBottomNavStates());
  }

  List<dynamic> business=[];

  void getBusiness()
  {
    emit(NewsGetBusinessLoadingStates());
    DioHelper.getData(
      url: 'v2/top-headlines',
      queryParams:
      {
        'country':'eg',
        'category':'business',
        'apiKey':'92e64cf37b2b4ac4b0bb15255f41f48e',
      },
    ).then((value)
    {
      // print(value.data['articles'][0]['author']);
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessStates());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorStates(error.toString()));
    });
  }

  List<dynamic> sports=[];

  void getSports()
  {
    emit(NewsGetSportsLoadingStates());
    if (sports.length == 0 )
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        queryParams:
        {
          'country':'eg',
          'category':'sports',
          'apiKey':'92e64cf37b2b4ac4b0bb15255f41f48e',
        },
      ).then((value)
      {
        // print(value.data['articles'][0]['author']);
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessStates());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorStates(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessStates());
    }
  }

  List<dynamic> science=[];

  void getScience()
  {
    emit(NewsGetScienceLoadingStates());
    if (science.length == 0 )
    {

      DioHelper.getData(
        url: 'v2/top-headlines',
        queryParams:
        {
          'country':'eg',
          'category':'science',
          'apiKey':'92e64cf37b2b4ac4b0bb15255f41f48e',
        },
      ).then((value)
      {
        // print(value.data['articles'][0]['author']);
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessStates());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorStates(error.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessStates());
    }
  }

  List<dynamic> search=[];

  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingStates());

    DioHelper.getData(
      url: 'v2/everything',
      queryParams:
      {
        'q':'$value',
        'apiKey':'92e64cf37b2b4ac4b0bb15255f41f48e',
      },
    ).then((value)
    {
      // print(value.data['articles'][0]['author']);
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessStates());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorStates(error.toString()));
    });
  }
}
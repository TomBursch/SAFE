import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/bloc.dart';
import 'package:safe/pages/account.dart';
import 'package:safe/pages/createNew.dart';
import 'package:safe/pages/map.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _homeBloc,
      listener: (context, HomeState state) {
        _pageController.animateToPage(state.pageIndex,
                  curve: Curves.linear, duration: Duration(milliseconds: 50));
      },
      child: BlocProvider(
        bloc: _homeBloc,
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              MapPage(),
              CreateNewPage(),
              AccountPage(),
            ],
          ),
          bottomNavigationBar: BlocBuilder<HomeEvent, HomeState>(
            bloc: _homeBloc,
            builder: (context, state) => BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  title: Text("Home"),
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  title: Text("Add"),
                  icon: Icon(Icons.add),
                ),
                BottomNavigationBarItem(
                  title: Text("Account"),
                  icon: Icon(Icons.account_circle),
                ),
              ],
              currentIndex: state.pageIndex,
              onTap: (i) {
                _homeBloc.dispatch(HomeEvent(i));
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }
}

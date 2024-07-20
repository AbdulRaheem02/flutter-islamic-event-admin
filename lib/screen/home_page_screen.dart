import 'package:islamic_event_admin/screen/home_page/MoreScreen.dart';
import 'package:islamic_event_admin/screen/home_page/books_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_export.dart';
import '../controller/initialStatuaController.dart';
import 'home_page/home_page.dart';
import 'home_page/project_page.dart';
import 'mentor/mentor_page.dart';
import 'sign_in_screen/sign_in_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 10),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          EventPageScreen(),
          MentorListPage(),
          ProjectsScreen(),
          BooksScreen(),
          MoreScreen()
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.zero,
        // color: Colors.green,
        // height: height * 0.09,
        child: BottomNavigationBar(
          elevation: 0,
          // backgroundColor: theme.colorScheme.background,
          backgroundColor: const Color.fromRGBO(157, 178, 214, 0.13),
          type: BottomNavigationBarType.fixed,

          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: _selectedIndex == 0
                    ? ColorFilter.mode(
                        theme.colorScheme.primary, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Color.fromARGB(255, 160, 162, 165), BlendMode.srcIn),
                child: CustomImageView(
                  imagePath: ImageConstant.calendaricon,
                  // height: height * 0.02,
                  height: height * 0.04,

                  width: width * 0.06,
                ),
              ),
              label: 'Event',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: _selectedIndex == 1
                    ? ColorFilter.mode(
                        theme.colorScheme.primary, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Color.fromARGB(255, 160, 162, 165), BlendMode.srcIn),
                child: CustomImageView(
                  imagePath: ImageConstant.mentor,
                  // height: height * 0.02,
                  height: height * 0.04,

                  width: width * 0.06,
                ),
              ),
              label: 'Mentor',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: _selectedIndex == 2
                    ? ColorFilter.mode(
                        theme.colorScheme.primary, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Color.fromARGB(255, 160, 162, 165), BlendMode.srcIn),
                child: CustomImageView(
                  imagePath: ImageConstant.projects,
                  // height: height * 0.02,
                  height: height * 0.04,

                  width: width * 0.06,
                ),
              ),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: _selectedIndex == 3
                    ? ColorFilter.mode(
                        theme.colorScheme.primary, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Color.fromARGB(255, 160, 162, 165), BlendMode.srcIn),
                child: CustomImageView(
                  imagePath: ImageConstant.books,
                  // height: height * 0.02,
                  height: height * 0.04,

                  width: width * 0.06,
                ),
              ),
              label: 'Books',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                  colorFilter: _selectedIndex == 4
                      ? ColorFilter.mode(
                          theme.colorScheme.primary, BlendMode.srcIn)
                      : const ColorFilter.mode(
                          Color.fromARGB(255, 160, 162, 165), BlendMode.srcIn),
                  child: Icon(
                    Icons.more_vert_sharp,
                    size: 35.h,
                  )),
              label: 'More',
            ),
          ],

          // iconSize: height * 0.05,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: const Color.fromARGB(255, 160, 162, 165),
          selectedFontSize: height * 0.015,

          unselectedFontSize: height * 0.015,
          selectedIconTheme: IconThemeData(
            color: theme.colorScheme.primary,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Color.fromARGB(255, 160, 162, 165),
          ),
        ),
      ),
    );
  }
}

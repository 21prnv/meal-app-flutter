import 'package:flutter/material.dart';
import 'package:meal_app/provider/meal_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/provider/filters_provider.dart';

import 'package:meal_app/screens/Filters.dart';
import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/provider/favorite_provider.dart';

const kIntialFilters = {
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
  Filters.vegetrianFree: false,
  Filters.veganFree: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndex = 0;

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filters, bool>>(
          MaterialPageRoute(builder: (ctx) => const FilterScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final availabelMeals = ref.watch(filtersProvider);
    Widget activePage = CategoryScreen(
      availabelMeals: availabelMeals,
    );
    String activeTitle = 'Categories';

    if (_selectedIndex == 1) {
      final selectedFavMeal = ref.watch(favoriteMealProvider);
      activePage = MealsScreen(
        meals: selectedFavMeal,
      );
      activeTitle = 'Favorites';
    }

    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setScreen),
      appBar: AppBar(
        title: Text(activeTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedPage,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.set_meal,
                ),
                label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: 'Favorites')
          ]),
    );
  }
}

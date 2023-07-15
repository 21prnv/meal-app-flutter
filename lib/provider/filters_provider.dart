import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/provider/meal_provider.dart';

enum Filters {
  glutenFree,
  lactoseFree,
  vegetrianFree,
  veganFree,
}

class FilterNotifier extends StateNotifier<Map<Filters, bool>> {
  FilterNotifier()
      : super({
          Filters.glutenFree: false,
          Filters.lactoseFree: false,
          Filters.vegetrianFree: false,
          Filters.veganFree: false,
        });

  void setFilters(Map<Filters, bool> choosedFilter) {
    state = choosedFilter;
  }

  void setFilter(Filters filters, bool isActive) {
    state = {...state, filters: isActive};
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, Map<Filters, bool>>((ref) {
  return FilterNotifier();
});

final filtersProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilter = ref.watch(filterProvider);
  return meals.where((meal) {
    if (activeFilter[Filters.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }

    if (activeFilter[Filters.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }

    if (activeFilter[Filters.vegetrianFree]! && !meal.isVegetarian) {
      return false;
    }

    if (activeFilter[Filters.veganFree]! && !meal.isVegan) {
      return false;
    }

    return true;
  }).toList();
});

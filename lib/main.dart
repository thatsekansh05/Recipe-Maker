import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatefulWidget {
  @override
  _RecipeAppState createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  final List<Recipe> _recipes = [
    Recipe(
      title: 'Pasta Carbonara',
      ingredients: ['Pasta', 'Eggs', 'Parmesan Cheese', 'Bacon'],
      instructions: 'Cook pasta. Mix eggs and cheese. Combine with bacon.',
    ),
    Recipe(
      title: 'Chicken Curry',
      ingredients: ['Chicken', 'Curry Powder', 'Coconut Milk', 'Onion'],
      instructions: 'Cook chicken with curry powder. Add coconut milk and onions.',
    ),
  ];

  String _searchQuery = '';
  Recipe? _selectedRecipe;
  bool _isAddingRecipe = false;

  void _addRecipe(Recipe recipe) {
    setState(() {
      _recipes.add(recipe);
      _isAddingRecipe = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = _recipes
        .where((recipe) =>
        recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return MaterialApp(
      home:Scaffold(
      appBar: AppBar(
        title: const Text('Recipe App'),
        actions: [
          IconButton(
            icon:const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _isAddingRecipe = !_isAddingRecipe;
                _selectedRecipe = null; // Clear selection when adding a new recipe
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isAddingRecipe)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AddRecipeForm(onSubmit: _addRecipe),
            )
          else
            ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search recipes...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return ListTile(
                      title: Text(recipe.title),
                      onTap: () {
                        setState(() {
                          _selectedRecipe = recipe;
                        });
                      },
                    );
                  },
                ),
              ),
              if (_selectedRecipe != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RecipeDetails(recipe: _selectedRecipe!),
                ),
            ],
        ],
      ),
      ),
    );
  }
}

class Recipe {
  final String title;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.instructions,
  });
}

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

 const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Using the default text style if `headline6` is not available
    final textTheme = Theme.of(context).textTheme;
    final headline6 = textTheme.titleLarge ?? textTheme.headlineSmall;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients',
              style: headline6,
            ),
            ...recipe.ingredients.map((ingredient) => Text('- $ingredient')),
           const SizedBox(height: 16),
            Text(
              'Instructions',
              style: headline6,
            ),
            Text(recipe.instructions),
          ],
        ),
      ),
    );
  }
}

class AddRecipeForm extends StatefulWidget {
  final Function(Recipe) onSubmit;

  const AddRecipeForm({super.key, required this.onSubmit});

  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  void _submit() {
    final title = _titleController.text;
    final ingredients = _ingredientsController.text.split('\n');
    final instructions = _instructionsController.text;

    if (title.isEmpty || ingredients.isEmpty || instructions.isEmpty) {
      return;
    }

    final newRecipe = Recipe(
      title: title,
      ingredients: ingredients,
      instructions: instructions,
    );

    widget.onSubmit(newRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients (one per line)'),
              maxLines: 5,
            ),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(labelText: 'Instructions'),
              maxLines: 5,
            ),
           const  SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child:const Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}

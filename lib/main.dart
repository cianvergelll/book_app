import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in (replace with your actual authentication logic)
    bool isLoggedIn = false; // Replace with your authentication logic

    return isLoggedIn ? const HomePage() : const LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    const String correctEmail = 'cianvergelll@gmail.com';
    const String correctPassword = 'ian123';

    if (_emailController.text == correctEmail && _passwordController.text == correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Image.asset(
                  'assets/it_guy.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white.withAlpha(229),
                        Colors.white.withAlpha(51),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 20,
                  bottom: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CodeShelf:',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        'Your Infinite IT Library',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Unlock the world of IT knowledge—anytime, anywhere.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Text('Login', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> cartItems = [];
  final List<Map<String, dynamic>> favoriteItems = [];
  final Map<String, bool> isFavorited = {
    'Flutter for Beginners': false,
    'Mastering Dart': false,
    'The Art of UI/UX Design': false,
    'Android Development': false,
    'iOS Development': false,
    'Machine Learning Basics': false,
  };
  String searchQuery = '';

  void _addToCart(String book, double price) {
    setState(() {
      cartItems.add({'title': book, 'price': price});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$book added to cart!')),
    );
  }

  void _toggleFavorite(String book, String imagePath, double price) {
    setState(() {
      isFavorited[book] = !isFavorited[book]!;
      if (isFavorited[book]!) {
        favoriteItems.add({'title': book, 'image': imagePath, 'price': price});
      } else {
        favoriteItems.removeWhere((item) => item['title'] == book);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isFavorited[book]! ? '$book added to favorites!' : '$book removed from favorites!')),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void _removeFromFavorites(int index) {
    setState(() {
      favoriteItems.removeAt(index);
    });
  }

  void _openCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CartPage(
          cartItems: cartItems,
          onRemoveItem: _removeFromCart,
        );
      },
    );
  }

  void _openFavorites() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FavoritesPage(
          favoriteItems: favoriteItems,
          onRemoveItem: _removeFromFavorites,
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  List<Map<String, dynamic>> get filteredBooks {
    return [
      {
        'title': 'Flutter for Beginners',
        'image': 'assets/flutter_book.jpg',
        'price': 999.99,
        'author': 'John Doe',
        'description': 'A comprehensive guide to Flutter development, covering everything from basic widgets to advanced state management.',
      },
      {
        'title': 'Mastering Dart',
        'image': 'assets/dart_book.jpg',
        'price': 849.99,
        'author': 'Jane Smith',
        'description': 'Learn Dart programming from the ground up, with a focus on building scalable and efficient applications.',
      },
      {
        'title': 'The Art of UI/UX Design',
        'image': 'assets/uiux_book.jpg',
        'price': 1299.99,
        'author': 'Alice Johnson',
        'description': 'Discover the principles of UI/UX design and how to create user-friendly interfaces for modern applications.',
      },
      {
        'title': 'Android Development',
        'image': 'assets/android_book.jpg',
        'price': 1099.99,
        'author': 'Bob Brown',
        'description': 'A complete guide to Android development, including best practices for building robust and performant apps.',
      },
      {
        'title': 'iOS Development',
        'image': 'assets/ios_book.jpg',
        'price': 1199.99,
        'author': 'Charlie Davis',
        'description': 'Master iOS development with Swift and Xcode, and learn how to build apps for the Apple ecosystem.',
      },
      {
        'title': 'Machine Learning Basics',
        'image': 'assets/ml_book.jpg',
        'price': 1599.99,
        'author': 'Eva Green',
        'description': 'An introduction to machine learning concepts, algorithms, and their applications in real-world scenarios.',
      },
    ].where((book) {
      final title = book['title'] as String; // Explicitly cast to String
      return title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book App Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.deepPurple, size: 30),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(filteredBooks, context),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.deepPurple, size: 30),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
          children: filteredBooks.map((book) {
            return _buildBookBlock(
              book['title'],
              book['image'],
              book['price'],
              book['author'],
              book['description'],
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.deepPurple, size: 30),
              onPressed: () {
                // Navigate to home
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.deepPurple, size: 30),
              onPressed: _openCart,
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
              onPressed: _openFavorites,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookBlock(
    String bookTitle,
    String imagePath,
    double price,
    String author,
    String description,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsPage(
              bookTitle: bookTitle,
              imagePath: imagePath,
              author: author,
              description: description,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    bookTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₱${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _addToCart(bookTitle, price),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                ),
                IconButton(
                  icon: Icon(
                    isFavorited[bookTitle]! ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited[bookTitle]! ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(bookTitle, imagePath, price),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveItem,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get totalPrice => widget.cartItems.fold(0.0, (sum, item) => sum + (item['price'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('No items in the cart!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.cartItems[index]['title']),
                        subtitle: Text('₱${widget.cartItems[index]['price'].toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            widget.onRemoveItem(index); // Remove item from the list
                            setState(() {}); // Rebuild the widget to reflect changes
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: ₱${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final Function(int) onRemoveItem;

  const FavoritesPage({
    super.key,
    required this.favoriteItems,
    required this.onRemoveItem,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: widget.favoriteItems.isEmpty
          ? const Center(child: Text('No favorites added!'))
          : ListView.builder(
              itemCount: widget.favoriteItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    widget.favoriteItems[index]['image'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(widget.favoriteItems[index]['title']),
                  subtitle: Text('₱${widget.favoriteItems[index]['price'].toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.onRemoveItem(index); // Remove item from the list
                      setState(() {}); // Rebuild the widget to reflect changes
                    },
                  ),
                );
              },
            ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final String bookTitle;
  final String imagePath;
  final String author;
  final String description;

  const BookDetailsPage({
    super.key,
    required this.bookTitle,
    required this.imagePath,
    required this.author,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Author: $author',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> books;
  final BuildContext context;

  BookSearchDelegate(this.books, this.context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books.where((book) => book['title']?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['title']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsPage(
                  bookTitle: results[index]['title'],
                  imagePath: results[index]['image'],
                  author: results[index]['author'],
                  description: results[index]['description'],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? books
        : books.where((book) => book['title']?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['title']),
          onTap: () {
            query = suggestions[index]['title'];
            showResults(context);
          },
        );
      },
    );
  }
}
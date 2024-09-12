import 'package:flutter/material.dart';
import 'package:sample_project/src/ui/image_view.dart';
import 'package:sample_project/src/ui/search_view.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String _query = "";
  bool imgCall = true;
  String tempQuery ="";
  bool openSearch = false;

  Widget _searchListView() {
    // Use the query entered by the user
    return SearchView(query: _query);
  }

  Widget _defaultImageView() {
    return const ImageView();
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          tempQuery = s; // Update the query when user types
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !openSearch ? const Text('Image Gallery') : _searchTextField(),
        actions: !openSearch
            ? [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                openSearch = true;
                 // Switch to search mode
              });
            },
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.done_outline),
            onPressed: () {
              setState(() {
                _query = tempQuery;
                // Finalize the search and trigger SearchView

                imgCall = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                openSearch = false;
                imgCall = true; // Go back to default view
                _query = ""; // Clear the search query
              });
            },
          ),
        ],
      ),
      body: imgCall
          ? _defaultImageView()
          : (_query.isNotEmpty
          ? _searchListView()
          : const Center(child: Text("No search query"))),
    );
  }
}

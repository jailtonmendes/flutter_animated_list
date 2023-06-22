import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Items da lista
  final _items = [];

  //Chave da lista
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  _addItem() {
    _items.insert(0, "Item ${_items.length + 1}");
    _key.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Scaffold(
          body: AnimatedList(
            key: _key,
            initialItemCount: 0,
            padding: const EdgeInsets.all(10),
            itemBuilder: ((context, index, animation) {
              return SizeTransition(
                key: UniqueKey(),
                sizeFactor: animation,
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 10,
                  color: Colors.blue,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: const Text('data'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addItem,
            child: const Icon(Icons.add),
          ),
        ));
  }
}

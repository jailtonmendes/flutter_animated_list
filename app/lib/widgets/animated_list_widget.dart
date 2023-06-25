import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reference_code/models/card_model.dart';

class AnimatedListWidget extends StatefulWidget {
  const AnimatedListWidget({super.key});

  @override
  State<AnimatedListWidget> createState() => _AnimatedListWidgetState();
}

class _AnimatedListWidgetState extends State<AnimatedListWidget> {
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  final TextEditingController _title = TextEditingController();
  final dateFormat = DateFormat('dd/MM/yyyy');
  final List<CardModel> listTask = [];
  final CardModel item = CardModel();

  Future<void> addDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Adicionar à lista de tarefas'),
          content: TextField(
            decoration:
                const InputDecoration(hintText: 'Ex.: Comprar, Estudar...'),
            onChanged: (value) {
              item.title = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                addItem();
                Navigator.pop(context);
              },
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 18, letterSpacing: 1),
              ),
            ),
          ],
        );
      }),
    );
  }

  void addItem() {
    final CardModel newItem = CardModel(
      id: listTask.length + 1,
      title: item.title,
      data: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      active: false,
    );

    listTask.add(newItem);
    _key.currentState!
        .insertItem(listTask.length - 1, duration: const Duration(seconds: 1));
  }

  void removeItem(int index, BuildContext context) {
    final removedItem = listTask.removeAt(index);

    AnimatedList.of(context).removeItem(index, (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          elevation: 2,
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            title: Text(
              removedItem.title.toString(),
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateTime.now().toString().substring(0, 10),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                size: 30,
              ),
            ),
          ),
        ),
      );
    });
  }

  void taskcheck(int id) {
    setState(() {
      for (int i = 0; i < listTask.length; i++) {
        if (listTask[i].id == id) {
          listTask[i].active = !listTask[i].active!;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = dateFormat.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Animated Todo List',
          style: TextStyle(color: Colors.white70, fontSize: 28),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.deepPurple.shade400,
            Colors.deepPurple.shade200,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedList(
            key: _key,
            initialItemCount: listTask.length,
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  key: UniqueKey(),
                  sizeFactor: animation,
                  child: Card(
                    elevation: 1,
                    color: listTask[index].active == true
                        ? Colors.green.shade100
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(
                        listTask[index].title.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  taskcheck(listTask[index].id!.toInt()),
                              icon: Icon(
                                Icons.check,
                                color: listTask[index].active == true
                                    ? Colors.green.shade900
                                    : Colors.grey,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () => removeItem(index, context),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _title.clear();
          addDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

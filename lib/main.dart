import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'notifier/todos_notifier.dart';
import 'models/todo_models.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App With Riverpod',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  showEditDialog(BuildContext ctx, Todo todoItem) {
    final editController = TextEditingController(text: todoItem.description);
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            content: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              controller: editController,
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    context.read(todoListProvider).editTodo(
                        description: editController.text, id: todoItem.id);
                    Navigator.pop(context);
                  },
                  child: Text("Save"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final descriptionController = TextEditingController();
    final todoList = useProvider(todoListProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App With Riverpod"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Enter Description",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (BuildContext context, int index) {
                var todoItem = todoList[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(todoItem.description.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => showEditDialog(context, todoItem)),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => context
                                .read(todoListProvider)
                                .removeTodo(id: todoItem.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read(todoListProvider)
              .addTodo(description: descriptionController.text);
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}

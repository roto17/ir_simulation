import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: const Text('IR Simulation !'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: List.generate(_count, (index){
          return Row(
            children: [
              const Text("Prime Panier "),
              const Text("500 DH"),
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(left: 5,bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  onPressed: (){
                    print("edit action ${index}");
                  }, icon: const Icon( Icons.edit,color: Colors.white, ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
                ),
                margin: const EdgeInsets.only(left: 5,bottom: 5),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  onPressed: (){

                    setState(() {
                      _count = _count - 1;
                    });
                    print("delete action ${index}");

                  }, icon: const Icon( Icons.delete,color: Colors.white,size: 20, ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _count++;
        }),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

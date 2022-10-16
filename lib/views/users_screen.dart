import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:store_app/api_services/api_services.dart';
import 'package:store_app/models/categories_model.dart';
import 'package:store_app/models/users_model.dart';
import 'package:store_app/widget/category_widget.dart';
import 'package:store_app/widget/users_widget.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body:  FutureBuilder<List<UsersModel>>(
        future: APIServices.getALlUsers(),
        builder: ((context, snapshot){
          if(snapshot.connectionState ==
              ConnectionState.waiting){
            return Center(
              child: GlowingProgressIndicator(
                child:  const Icon(Icons.groups, color: Colors.pink, size: 50.0,),
              ),
            );
          } else if(snapshot.hasError){
            Center(
              child: Text("An error occured ${snapshot.error}"),
            );
          } else if(snapshot.data == null){
            const Center(
              child: Text("No product has been added yet"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index){
              return ChangeNotifierProvider.value(
                value: snapshot.data![index],
                child: const UsersWidget(),
              );
            }
          );
        }),
      ),

    );
  }
}

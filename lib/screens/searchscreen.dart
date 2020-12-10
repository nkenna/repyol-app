import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/providers/productsprovider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());
  }

  initData() async{

    Provider.of<ProductsProvider>(context, listen: false).retrieveDataSearch();

  }

  Widget topBar(){
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_ios, color: mainColor3,),
                onPressed: (){
                  Get.back();
                }),
            Expanded(
                child: TextField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                )
            ),
            SizedBox(width: 10,),
            IconButton(
                icon: Icon(Icons.search_sharp, color: mainColor3,),
                onPressed: (){
                  if(searchController.text.isNotEmpty){
                    Provider.of<ProductsProvider>(context, listen: false).addSearch(searchController.text);
                    Provider.of<ProductsProvider>(context, listen: false).saveDataSearch();
                    Provider.of<ProductsProvider>(context, listen: false).getAllProductsBySearch(searchController.text);
                    searchController.clear();
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: Get.width,
            height: Get.height,
            child: Column(
              children: [
                topBar(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: Provider.of<ProductsProvider>(context, listen: true).searches.length,
                  itemBuilder: (BuildContext context, int i){
                    return ListTile(
                      onTap: (){
                        if(Provider.of<ProductsProvider>(context, listen: false).searches[i] != null){
                          setState(() {
                            searchController.text = Provider.of<ProductsProvider>(context, listen:false).searches[i];
                          });
                        }
                      },
                      leading: Icon(Icons.history, color: mainColor3,),
                      title: Text(Provider.of<ProductsProvider>(context, listen: true).searches[i] ?? "", style: TextStyle(fontSize: 12),),
                      trailing: Icon(Icons.arrow_back, color: mainColor3,),
                    );
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}

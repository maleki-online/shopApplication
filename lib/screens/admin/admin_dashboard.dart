import 'package:digital_shop/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

// داشبرد ادمین
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('پنل مدیریت'),
      ),
      drawer: AdminDrawer(
          currentRoute: ModalRoute.of(context)?.settings.name ?? ''),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/add-product');
                },
                child: Container(
                  height: 100,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.teal[700],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 40,
                      ),
                      Text(
                        'افزودن محصول',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/admin-product-list');
                },
                child: Container(
                  height: 100,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.teal[700],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.shopping_cart_sharp,
                        size: 40,
                      ),
                      Text(
                        'لیست محصولات',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/manage-categories');
            },
            child: Container(
              height: 100,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: Colors.transparent),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.category,
                    size: 40,
                  ),
                  Text(
                    'مدیریت دسته بندی ',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/manage-orders');
            },
            child: Container(
              height: 100,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: Colors.transparent),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.list_alt_outlined,
                    size: 40,
                  ),
                  Text(
                    ' مدیریت سفارشات',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/manage-users');
            },
            child: Container(
              height: 100,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: Colors.transparent),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.manage_accounts_outlined,
                    size: 40,
                  ),
                  Text(
                    'مدیریت کاربران',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

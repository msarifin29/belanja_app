import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {Key? key, required this.imageUrl, required this.title, required this.id})
      : super(key: key);

  final String id;
  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/edit-product', arguments: id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(
                    context,
                  ).primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ],
          )),
    );
  }
}

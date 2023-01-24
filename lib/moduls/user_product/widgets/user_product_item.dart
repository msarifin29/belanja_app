import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/share/product_provider/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.id,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
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
                Navigator.of(context).pushNamed('/edit-product', arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                  // await context.read<Products>().deleteProduct(id);
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting Successfully!'),
                    ),
                  );
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting failed!'),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

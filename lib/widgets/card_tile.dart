import 'package:flutter/material.dart';
import 'package:golekos_admin/pages/order_summary_page.dart';
import '../models/product.dart';

class CardTile extends StatefulWidget {
  const CardTile({
    Key? key,
    required this.id,
    required this.data,
  }) : super(key: key);

  final id;
  final Map<String, dynamic> data;

  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  String kostName = 'Product name';
  String imageUrl = 'https://via.placeholder.com/150';

  @override
  void initState() {
    super.initState();
    getKost(widget.data['kostID']).then((value) {
      setState(() {
        kostName = value.name;
        imageUrl = value.imageUrl;
      });
    });
  }

  Future<Product> getKost(int id) async {
    var productById = await Product.getProductById(id);
    return productById;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new ListTile(
        onTap: () {
          var route = MaterialPageRoute(builder: (context) {
            return OrderSummary(id: widget.id, object: widget.data);
          });

          Navigator.of(context).push(route);
        },
        leading: Image.network(
          imageUrl,
          width: 50,
          height: 50,
        ),
        title: new Container(
          width: 100,
          child: Text(
            '# ${widget.data['orderID']}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: new Text(widget.data['booking_date']),
        trailing: Container(
          child: Text(
            (widget.data['paid'] == false) ? 'Unpaid' : 'Paid',
            style: TextStyle(color: Colors.white),
          ),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: (widget.data['paid'] == false)
                  ? Color(0xffFFC33A)
                  : Colors.green,
              borderRadius: BorderRadius.circular(5)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      ),
    );
  }
}

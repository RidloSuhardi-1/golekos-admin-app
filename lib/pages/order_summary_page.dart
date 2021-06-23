import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme.dart';
import 'package:intl/intl.dart';

import '../widgets/order_summary_row.dart';

enum payment { transfer, onsite }

class OrderSummary extends StatefulWidget {
  OrderSummary({required this.object, required this.id});

  final id;
  final Map<String, dynamic> object;
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  CollectionReference ordersReference =
      FirebaseFirestore.instance.collection('orders');

  String paymentSelected = 'Onsite';

  String img = 'https://via.placeholder.com/150';
  String kostName = 'Product name';
  String type = 'Product type';
  int price = 0;
  String owner = 'Product owner';
  String ownerPhone = 'Product phone';

  @override
  void initState() {
    super.initState();
    getKost(widget.object['kostID']).then((value) {
      setState(() {
        kostName = value.name;
        img = value.imageUrl;
        type = value.type;
        price = value.price;
        owner = value.owner;
        ownerPhone = value.ownerPhone;
      });
    });
  }

  Future<Product> getKost(int id) async {
    var productById = await Product.getProductById(id);
    return productById;
  }

  Future<void> updatePayment() {
    return ordersReference.doc(widget.id).update({'paid': true}).then((_) {
      print('Success');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }).catchError((error) => print('Failed to update order payment: $error'));
  }

  Future<dynamic> paymentAccept(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Accept Payment ?'),
            content: Text('Accept order #${widget.object['orderID']}'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Not now',
                  )),
              TextButton(
                  onPressed: updatePayment,
                  child: Text(
                    'Yes, accept payment',
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3));

    final currencyFormat = NumberFormat("#,##0", "en_US");

    return Scaffold(
      backgroundColor: Color(0xffF2F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              children: [
                // Title Order Section

                AppBar(
                  centerTitle: true,
                  title: Text(
                    'ORDER #${widget.object['orderID']}',
                    style: orderBold.copyWith(color: orderBlack),
                  ),
                  leading: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: orderGrey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),

                SizedBox(
                  height: 35,
                ),

                // Order Summary Section

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order summary',
                        style: orderBold.copyWith(color: orderBlack),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Kost image and details

                      Row(
                        children: [
                          Image.network(
                            img,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                child: Text(
                                  kostName,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      orderRegular.copyWith(color: orderBlack),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                type,
                                style: orderLight.copyWith(
                                    fontSize: 12, color: Color(0xffA5A5A5)),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(
                        height: 22,
                      ),
                      Divider(
                        color: Color(0xffd8d8d8),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Order Details

                      OrderRow(
                        title: 'Owner',
                        value: owner,
                      ),
                      OrderRow(
                        title: 'Phone',
                        value: ownerPhone,
                      ),

                      Divider(
                        color: Color(0xffd8d8d8),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      OrderRow(
                        title: 'Rent Month',
                        value: '${widget.object['long_rented']} Months',
                      ),
                      OrderRow(
                        title: 'Rental Price /month',
                        value: 'IDR ${currencyFormat.format(price)}',
                      ),
                      OrderRow(
                        title: 'Total Price',
                        value:
                            'IDR ${currencyFormat.format(widget.object['total'])}',
                      ),
                      OrderRow(
                        title: 'Phone',
                        value: widget.object['phone'],
                      ),
                      OrderRow(
                        title: 'Tax',
                        value: '10%',
                      ),
                      OrderRow(
                        title: 'Payment Status',
                        value: (widget.object['paid'] == false)
                            ? 'Unpaid'
                            : 'Paid',
                        isPaymentStatus: true,
                      ),
                      Divider(
                        color: Color(0xffd8d8d8),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      OrderRow(
                        title: 'Total',
                        value:
                            'IDR ${currencyFormat.format(widget.object['total'])}',
                        isTotal: true,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                // Payment Section

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: orderBold.copyWith(color: Color(0xff000000)),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/payment/visa.png',
                                width: 43,
                                height: 26,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (paymentSelected ==
                                            widget.object['payment'])
                                        ? 'On site'
                                        : 'Bank transfer',
                                    style: orderMedium.copyWith(
                                        fontSize: 12, color: Color(0xff000000)),
                                  ),
                                  Text(
                                    (paymentSelected ==
                                            widget.object['payment'])
                                        ? 'No details needed'
                                        : '••••   ••••   ••••   1996',
                                    style: orderSemiBold.copyWith(
                                        fontSize: 10, color: Color(0xff000000)),
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          )),

                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Color(0xffd4d4d4),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // Promo code

                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            (widget.object['paid'])
                                ? print('Already Paid')
                                : paymentAccept(context);
                          },
                          child: Text((widget.object['paid'])
                              ? 'ALREADY PAID'
                              : 'ACCEPT PAYMENT'),
                          style: ElevatedButton.styleFrom(
                            primary: (widget.object['paid'])
                                ? Colors.grey.withOpacity(0.5)
                                : Color(0xffFFC33A),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            textStyle: orderMedium.copyWith(
                                fontSize: 12, color: Color(0xff414B5A)),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),

                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

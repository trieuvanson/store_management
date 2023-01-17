import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import '/constants/contains.dart';
import '/screens/check_sheet_products_screen/core/detail_bloc/product_bloc.dart';
import '/screens/screens.dart';
import '/utils/date_utils.dart';
import '/utils/utils.dart';
import '/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

import '../model/product_dto.dart';

class CheckSheetDetailScreen extends StatefulWidget {
  static const String routeName =
      '${CheckSheetProductsScreen.routeName}/product-detail-screen/:checkSheetId';
  final ProductDTO product;
  final int index;

  const CheckSheetDetailScreen(
      {Key? key, required this.product, required this.index})
      : super(key: key);

  @override
  State<CheckSheetDetailScreen> createState() => _CheckSheetDetailScreenState();
}

class _CheckSheetDetailScreenState extends State<CheckSheetDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late ProductBloc _productBloc;
  late String _name;
  late double _price;
  late double _inventory;
  late double _inventoryCurrent;
  late String _imageUrl;
  late List<Expiry> _expires;

  @override
  void initState() {
    super.initState();
    _productBloc = BlocProvider.of<ProductBloc>(context);
    //copy product not to change the original product

    var product = widget.product;
    _name = product.name!;
    _price = product.price!;
    _inventory = product.inventory!;
    _inventoryCurrent = product.inventoryCurrent;
    _imageUrl = product.image;
    _expires = List.from(product.expires!);
  }

  _onEdit() {
    ProductDTO product = ProductDTO(
      id: widget.product.id,
      code: widget.product.code,
      name: _name,
      price: _price,
      inventory: _inventory,
      inventoryCurrent: _inventoryCurrent,
      image: _imageUrl,
      expires: _expires,
    );
    _productBloc.add(EditProductEvent(
        product: product, index: widget.index, action: "DETAIL"));
  }

  // _dispose() {
  //   _expires = List.from(_expiresTemp);
  //   ProductDTO product = ProductDTO(
  //     id: widget.product.id,
  //     code: widget.product.code,
  //     name: _name,
  //     price: _price,
  //     inventory: _inventory,
  //     inventoryCurrent: _inventoryCurrent,
  //     image: _imageUrl,
  //     expires: _expires,
  //   );
  //   _productBloc.add(EditProduct(product: product, index: widget.index, action: "DETAIL"));
  // }

  @override
  void dispose() {
    // _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.close(1);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.dialog(const AddExpiryDialog());
          if (result != null) {
            setState(() {
              _expires.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //Name only display, and many lines, cannot focus
                SizedBox(
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        child: Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                20.heightBox,
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  maxLines: null,
                  readOnly: true,
                ),
                20.heightBox,
                TextFormField(
                  initialValue: widget.product.code,
                  decoration: const InputDecoration(
                    labelText: 'Mã sản phẩm',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  maxLines: null,
                  readOnly: true,
                ),
                20.heightBox,
                //Giá tiền (price)
                TextFormField(
                  initialValue: convertToVND(_price),
                  decoration: const InputDecoration(
                    labelText: 'Giá tiền',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  maxLines: null,
                  readOnly: true,
                ),
                //Số lượng tồn kho (inventory)
                20.heightBox,
                TextFormField(
                  initialValue: _inventory.toInt().toString(),
                  decoration: const InputDecoration(
                    labelText: 'Số lượng tồn kho',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  maxLines: null,
                  readOnly: true,
                ),
                //Số lượng hiện tại (inventoryCurrent), can edit
                20.heightBox,
                TextFormField(
                  initialValue: _inventoryCurrent.toInt().toString(),
                  decoration: const InputDecoration(
                    labelText: 'Tồn kho hiện tại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  onChanged: (value) {
                    try {
                      if (value.isEmpty) {
                        setState(() {
                          _inventoryCurrent = 0;
                        });
                      } else {
                        setState(() {
                          _inventoryCurrent = double.parse(value);
                        });
                      }
                    } catch (e) {}
                  },
                ),
                _buildExpiryList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  _buildExpiryList() {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _expires.length,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Hạn sử dụng ${index + 1}',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _expires.removeAt(index);
                        print('remove');
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: Column(
                  children: [
                    TextFormField(
                        readOnly: true,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                _expires[index].date =
                                    dateUtils.getFormattedDateByCustom(
                                        value, 'dd/MM/yyyy');
                              });
                            }
                          });
                        },
                        controller: TextEditingController(
                          text: _expires[index].date,
                        ),
                        decoration: InputDecoration(
                            labelText: 'Ngày/Tháng/Năm (dd/MM/yyyy)',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _expires[index].date =
                                          dateUtils.getFormattedDateByCustom(
                                              value, 'dd/MM/yyyy');
                                    });
                                  }
                                });
                              },
                              color: Theme.of(context).primaryColor,
                              icon: const Icon(Icons.calendar_today),
                            )),
                        maxLines: null,
                        onChanged: (value) {
                          setState(() {
                            _expires[index].date = value;
                          });
                        }),
                    20.heightBox,
                    TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue:
                            _expires[index].quantity!.toInt().toString(),
                        decoration: const InputDecoration(
                          labelText: 'Số lượng',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          try {
                            if (value.isEmpty) {
                              setState(() {
                                _expires[index].quantity = 0;
                              });
                            } else {
                              setState(() {
                                _expires[index].quantity = double.parse(value);
                              });
                            }
                          } catch (e) {}
                        }),
                  ],
                )),
          );
        },
      ),
    );
  }

  _bottomButton() {
    return Container(
      height: 60,
      color: kPrimaryColor,
      child: TextButton(
        onPressed: _onEdit,
        child: const Text(
          'Lưu lại',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}

class AddExpiryDialog extends StatefulWidget {
  const AddExpiryDialog({Key? key}) : super(key: key);

  @override
  _AddExpiryDialogState createState() => _AddExpiryDialogState();
}

class _AddExpiryDialogState extends State<AddExpiryDialog> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _manufacturingDate;
  late double _quantity;

  @override
  void initState() {
    _manufacturingDate = DateTime.now();
    _quantity = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm lô hàng'),
      content: SizedBox(
        width: 300,
        height: 200,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2050),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _manufacturingDate = value;
                        });
                      }
                    });
                  },
                  controller: TextEditingController(
                    text: dateUtils.getFormattedDateByCustom(
                        _manufacturingDate, 'dd/MM/yyyy'),
                  ),
                  decoration: InputDecoration(
                      labelText: 'Ngày/Tháng/Năm (dd/MM/yyyy)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2050),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                _manufacturingDate = value;
                              });
                            }
                          });
                        },
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.calendar_today),
                      )),
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {});
                  }),
              20.heightBox,
              TextFormField(
                initialValue: _quantity.toInt().toString(),
                decoration: const InputDecoration(
                  labelText: 'Số lượng',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLines: null,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      _quantity = 0;
                    });
                  } else {
                    setState(() {
                      _quantity = double.parse(value);
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Huỷ bỏ'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final date = dateUtils.getFormattedDateByCustom(
                  _manufacturingDate, 'dd/MM/yyyy');

              Navigator.pop(context, Expiry(date: date, quantity: _quantity));
            }
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _handleSavePicture() async {
    if (await _generateStoragePermissions()) {
      return;
    }

    final sign = _sign.currentState;
    //retrieve image data, do whatever you want with it (send to server, save locally...)
    final image = await sign?.getData();
    // final imageWhiteBackground = await _changeBackground(image);
    // var data = await image?.toByteData(format: ui.ImageByteFormat.png);
    var data = await _changeBackground(image);
    sign?.clear();
    //save image with white background
    final result = await ImageGallerySaver.saveImage(data!.buffer.asUint8List(),
        quality: 60, name: 'signature');
    setState(() {
      _img = data;
    });
  }

  //image with white background
  Future<ByteData?> _changeBackground(ui.Image? image) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.white;
    final rect =
        Rect.fromLTWH(0, 0, image!.width.toDouble(), image.height.toDouble());
    canvas.drawRect(rect, paint);
    canvas.drawImage(image, Offset.zero, Paint());
    final picture = recorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data;
  }

  _generateStoragePermissions() async {
    final isStorage = await Permission.storage.status;
    if (!isStorage.isGranted) {
      await Permission.storage.request();
    }
    return isStorage.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                  },
                  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
          ),
          _img.buffer.lengthInBytes == 0
              ? Container()
              : LimitedBox(
                  maxHeight: 200.0,
                  child: Image.memory(_img.buffer.asUint8List())),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      color: Colors.green,
                      onPressed: _handleSavePicture,
                      text: 'Save'),
                  CustomButton(
                      color: Colors.grey,
                      onPressed: () {
                        final sign = _sign.currentState;
                        sign?.clear();
                        setState(() {
                          _img = ByteData(0);
                        });
                      },
                      text: "Clear"),
                ],
              ),
/*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                      onPressed: () {
                      },
                    icon: const Icon(Icons.draw_sharp, size: 30,),
                  ),
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          int min = 1;
                          int max = 10;
                          int selection = min + (Random().nextInt(max - min));
                          strokeWidth = selection.roundToDouble();
                        });
                      },
                      child: const Text("Change stroke width")),
                ],
              ),
*/
            ],
          )
        ],
      ),
    );
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(const Offset(0, 0), 10.8, Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

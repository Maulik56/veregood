import 'package:hive/hive.dart';
import 'package:veregood_flutter/model/product_model.dart';

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      isApproved: fields[8] as bool,
      title: fields[0] as String,
      coverImage: fields[1] as String,
      chooseCategory: fields[2] as String,
      productDescription: fields[3] as String,
      quantity: fields[4] as String,
      listOfImage: fields[5] as List<String>,
      price: fields[6] as String,
      availableColours: fields[7] as List<String>,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.coverImage)
      ..writeByte(2)
      ..write(obj.chooseCategory)
      ..writeByte(3)
      ..write(obj.productDescription)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.listOfImage)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.availableColours)
      ..writeByte(8)
      ..write(obj.isApproved);
  }
}

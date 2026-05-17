import 'package:hive/hive.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final int colorValue;
  final int iconCode;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCode,
  });
}

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 1;

  @override
  ExpenseCategory read(BinaryReader reader) {
    return ExpenseCategory(
      id: reader.readString(),
      name: reader.readString(),
      colorValue: reader.readInt(),
      iconCode: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.colorValue);
    writer.writeInt(obj.iconCode);
  }
}

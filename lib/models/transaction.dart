import 'package:hive/hive.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String categoryId;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.isIncome,
  });
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      categoryId: reader.readString(),
      isIncome: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.categoryId);
    writer.writeBool(obj.isIncome);
  }
}

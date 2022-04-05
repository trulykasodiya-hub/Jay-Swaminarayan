
import '../Controller/database_helper.dart';

class MantraJapModel {
  int? id;
  String? count;
  String? date;

  MantraJapModel(this.id, this.count, this.date);

  MantraJapModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    count = map['count'];
    date = map['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnCount: count,
      DatabaseHelper.columnDate: date,
    };
  }
}

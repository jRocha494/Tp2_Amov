import 'Menu.dart';

class WeekDay {
  late String weekDay;
  late Menu original;
  late Menu? update;

  @override
  String toString() {
    return update != null ? update.toString() : original.toString();
  }

  String? getImgUrl(){
    if(update?.img != null){
      return update!.img!;
    }

    if(original.img != null){
      return original.img!;
    }

    return null;
  }
}
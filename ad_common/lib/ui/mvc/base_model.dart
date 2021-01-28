

abstract class BaseModel {


}

abstract class BaseBean<T> {

  List<T> listData = [];

  void initJsonData(Object json);
}
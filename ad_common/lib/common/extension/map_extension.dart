
extension MapOption<K, V> on Map {

  V objectForKey(K key){
    if(containsKey(key)){
      return this[key];
    } else {
      return null;
    }
  }




}


extension MapOption<K, V> on Map {

  V value(K key){
    if(containsKey(key)){
      return this[key];
    } else {
      return null;
    }
  }

  void set({K key, V obj}){
    if(key == null) return;
    if(obj == null) {
      this.remove(key);
    } else {
      this[key] = obj;
    }
  }
}

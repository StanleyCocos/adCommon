extension MapOption<K, V> on Map {

  V? value(K key) {
    if (containsKey(key)) {
      return this[key];
    } else {
      return null;
    }
  }

  void set({K? key, V? obj}) {
    if (key == null) return;
    if (obj == null) {
      this.remove(key);
    } else {
      this[key] = obj;
    }
  }

  void add(K key, V value) {
    if (key == null) return;
    if (this.containsKey(key)) {
      this.update(key, (value) => value);
    } else {
      this.putIfAbsent(key, () => value);
    }
  }
}

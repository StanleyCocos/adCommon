

import 'dart:math';

extension ListOption<E> on List {

  E get random {
    if(this == null || this.length <= 0) return null;
    return this[Random().nextInt(this.length - 1)];
  }

}
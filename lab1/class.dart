abstract class Iterator {
  int next();
  Iterator();
  factory Iterator.from(dynamic src) {
    if (src is List) {
      return ListIterator(src);
    } else if (src is int) {
      return RepeatIterator(src);
    }
    throw "Can't create iterator from $src";
  }
}

mixin Mappable on Iterator {
  MapIterator map(Function callback) => MapIterator(this, callback);
}

mixin Filter on Iterator {
  FilterIterator filter(Function callback) => FilterIterator(this, callback);
}

mixin Collectable on Iterator {
  List<int> collect() {
    var res = <int>[];
    while (true) {
      var next = this.next();
      if (next != null) {
        res.add(next);
      } else {
        break;
      }
    }
    return res;
  }
}

class ListIterator extends Iterator with Mappable, Collectable, Filter {
  List<int> _list;
  int _index;

  ListIterator(this._list) {
    _index = 0;
  }
  int next() => (_index < _list.length) ? _list[_index++] : null;
}

class MapIterator extends Iterator with Mappable, Collectable, Filter {
  Function _callback;
  Iterator _iter;

  MapIterator(this._iter, this._callback);

  int next() {
    var val = _iter.next();
    return val == null ? val : _callback(val);
  }
}

class FilterIterator extends Iterator with Mappable, Collectable, Filter {
  Function _callback;
  Iterator _iter;

  FilterIterator(this._iter, this._callback);

  int next() {
    while (true) {
      var val = _iter.next();
      if (val == null) {
        return null;
      }
      if (_callback(val)) {
        return val;
      }
    }
  }
}

class RepeatIterator extends Iterator with Mappable, Collectable, Filter {
  int _val;

  RepeatIterator([this._val = 0]);

  int next() => _val;
}

void main(List<String> args) {
  var low = 5;
  var moreThanLow = ListIterator([1, 2, 3, 4])
      .map((a) => a * a)
      .filter((a) => low < a)
      .collect();
  print("low < $moreThanLow");

  var dynam = Iterator.from(1);
  assert(dynam is RepeatIterator);

  var list = [1, 2, 1, 1, 3, 4, 1, 1];
  var occurences = <int, int>{};
  ListIterator(list)
      .map((a) => occurences.update(a, (val) => val + 1, ifAbsent: () => 1))
      .collect();
  var unique = <int>{};
  list.forEach((element) {
    unique.add(element);
  });
  print("list = $list");
  print("occurences = $occurences");
  print("unique = $unique");
}

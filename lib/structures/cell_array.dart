class CellArray {
  final bool allowNegativeValues;
  late List<int> cells;
  late List<int>? negativeCells;
  late int? rightLimit;
  late int? leftLimit;

  (int? nIndex, int aIndex, int? pIndex) _currCell = (null, 0, 0);

  CellArray(
    this.allowNegativeValues,
    bool allowNegativeCells,
    String cellsLimit,
  ) {
    int? overallLimit = int.tryParse(cellsLimit);

    if(overallLimit == null) {
      cells = [0];
      negativeCells = allowNegativeCells ? [] : null;
      rightLimit = null;
      leftLimit = allowNegativeCells ? null : 0;
    } else {
      if(allowNegativeCells) {
        int smallestHalf = overallLimit ~/ 2;

        cells = List<int>.filled(
          rightLimit = smallestHalf + (overallLimit % 2 == 0 ? 0 : 1), 
          0
        );
        negativeCells = List<int>.filled(smallestHalf, 0);
        leftLimit = -(smallestHalf - 1);
        return;
      }

      cells = List<int>.filled(rightLimit = overallLimit, 0);
      leftLimit = 0;
      negativeCells = null;
    }
  }

  bool get _currCellIsPositive => _currCell.$2 >= 0;

  void _updateCellsFeed() {
    if(_currCellIsPositive) {
      while(cells.length - 1 < _currCell.$3!) {
        cells.add(0);
      }
      return;
    }

    while(negativeCells!.length - 1 < _currCell.$1!) {
      negativeCells!.add(0);
    }
  }

  void moveRight() {
    if(_currCell.$2 >= (rightLimit ?? double.infinity)) {
      throw Exception("Can't move right because there is a $rightLimit cell limit for positive cells.");
    }

    if(_currCell.$2 + 1 >= 0) {
      _currCell = (
        null,
        _currCell.$2 + 1,
        _currCell.$2 + 1
      );

      return;
    }

    _currCell = (
      -_currCell.$2 - 2,
      _currCell.$2 + 1,
      null
    );
  }

  void moveLeft() {
    if(_currCell.$2 <= (leftLimit ?? -double.infinity)) {
      throw Exception(
        "Can't move left because there is a ${-(leftLimit ?? 0)} cell limit for negative cells."
      );
    }

    if(_currCell.$2 - 1 >= 0) {
      _currCell = (
        null,
        _currCell.$2 - 1,
        _currCell.$2 - 1
      );

      return;
    }

    _currCell = (
      -_currCell.$2,
      _currCell.$2 - 1,
      null
    );
  }

  void increment() {
    _updateCellsFeed();

    if(_currCellIsPositive) {
      cells[_currCell.$3!]++;
      return;
    }

    negativeCells![_currCell.$1 ?? -1]++;
  }

  void decrement() {
    if(!allowNegativeValues && currValue <= 0) {
      throw Exception("Can't decrement #${_currCell.$2} cell as its value is already zero.");
    }

    _updateCellsFeed();

    if(_currCellIsPositive) {
      cells[_currCell.$3!]--;
      return;
    }

    negativeCells![_currCell.$1!]--;
  }

  set currValue(int value) {
    if(!allowNegativeValues && value < 0) {
      throw Exception("Can't insert negative value in cell #${_currCell.$2}.");
    }

    _updateCellsFeed();

    if(_currCellIsPositive) {
      cells[_currCell.$3!] = value;
      return;
    }

    negativeCells![_currCell.$1!] = value;
  }

  int get currValue {
    _updateCellsFeed();

    if(_currCellIsPositive) {
      return cells[_currCell.$3!];
    }

    return negativeCells![_currCell.$1!];
  }
}
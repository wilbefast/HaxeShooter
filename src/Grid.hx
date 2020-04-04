@:allow(Grid)
class Tile<T> {
  public var x(default, null) : Int;
  public var y(default, null) : Int;
  public var grid(default, null) : Grid<T>;
  public var contents(default, null) : T;
  public var N(default, null) : Tile<T>;
  public var S(default, null) : Tile<T>;
  public var E(default, null) : Tile<T>;
  public var W(default, null) : Tile<T>;

  public function new(args : {
    grid : Grid<T>,
    x : Int,
    y : Int
  }) {
    Useful.assert(args.grid != null, "args.grid cannot be null");
    grid = args.grid;
    x = args.x;
    y = args.y;
  }

  public function isAdjacentTo(other : Tile<T>) {
    Useful.assert(grid == other.grid, 'only tiles in same grid can be adjacent');
    Useful.assert(other != null, 'other cannot be null');
    return other == N || other == S || other == E || other == W;
  }
}

class Grid<T> {
  public var width(default, null) : Int;
  public var height(default, null) : Int;

  private var tiles : Array<Tile<T>>;
  private var indices : Array<Int>;

  public function new(args : {
    width : Int,
    height : Int,
    factory : Tile<T>->T
  }) {
    Useful.assert(width > 0, 'args.width must be strictly positive');
    Useful.assert(height > 0, 'args.height must be strictly positive');
    width = args.width;
    height = args.height;

    // create tiles
    var factory = args.factory;
    tiles = new Array<Tile<T>>();
    for(x in 0 ... width) {
      for(y in 0 ... height) {
        var tile = new Tile<T>({
          x : x,
          y : y,
          grid : this
        });
        tile.contents = factory(tile);
        tiles[y*width + x] = tile;
      }
    }
    
    // create index list
    indices = new Array<Int>();
    for(i in 0 ... tiles.length - 1) {
      indices[i] = i;
    }

    // cache neighbourhoods
    for(tile in tiles) {
      tile.N = tryGetTile(tile.x, tile.y - 1);
      tile.S = tryGetTile(tile.x, tile.y + 1);
      tile.E = tryGetTile(tile.x + 1, tile.y);
      tile.W = tryGetTile(tile.x - 1, tile.y);
    }
  }

  public function isValid(x : Int, y : Int) : Bool {
    return (x >= 0 && y >= 0 && x < width && y < height); 
  }

  public function tryGetTile(x : Int, y : Int) : Tile<T> {
    return isValid(x, y) ? tiles[y*width + x] : null;
  }

  public function getTile(x : Int, y : Int) : Tile<T> {
    Useful.assert(isValid(x, y), '$x, $y is an invalid Grid position');
    return tiles[y*width + x];
  }

  public function getMiddle() : Tile<T> {
    return tiles[Math.floor(height/2)*width + Math.floor(width/2)];
  }

  public function getCornerNW() : Tile<T> {
    return tiles[0];
  }

  public function getCornerNE() : Tile<T> {
    return tiles[width - 1];
  }

  public function getCornerSE() : Tile<T> {
    return tiles[tiles.length - 1];
  }

  public function getCornerSW() : Tile<T> {
    return tiles[(height - 1)*width];
  }

  public function getRandom(suchThat : Tile<T>->Bool) : Tile<T> {
    Useful.shuffle(indices);
    if(suchThat == null) {
      return tiles[indices[0]];
    }
    else {
      for(i in 0 ... indices.length) {
        var t = tiles[indices[i]];
        if(suchThat(t)) {
          return t;
        }
      }
      return null;
    }
  }

  public function forEach(f : Tile<T>->Int->Int->Void) {
    for(x in 0 ... width) {
      for(y in 0 ... height) {
        f(tiles[y*width + x], x, y);
      }
    }
  }
}
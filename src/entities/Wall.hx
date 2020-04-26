import h2d.Object;

enum RelativePosition {
  Above;
  Below;
  Left;
  Right;
  AboveRight;
  BelowRight;
  BelowLeft;
  AboveLeft;
  Around;
}

class Wall extends Entity {

  public var width(default, null) : Float;
  public var height(default, null) : Float;

  public function new(args : {
    parent : h2d.Layers,
    x : Float,
    y : Float,
    width : Float,
    height : Float
  }) {
    super(args.parent);

    x = args.x;
    y = args.y;
    
    Useful.assert(args.width >= 0, "args.width must be positive");
    width = args.width;
    Useful.assert(args.height >= 0, "args.height must be positive");
    height = args.height;

    collider = new EntityCollider(this, width, height);
  }

  public function getPositionRelativeTo(entity : Entity) : RelativePosition {
    return switch([entity.x < x, entity.y < y, entity.x > x + width, entity.y > y + height]) {
      case [right, below, left, above] if(left && above): AboveLeft;
      case [right, below, left, above] if(left && below): BelowLeft;
      case [right, below, left, above] if(right && above): AboveRight;
      case [right, below, left, above] if(right && below): BelowRight;
      case [right, below, left, above] if(right): Right;
      case [right, below, left, above] if(left): Left;
      case [right, below, left, above] if(above): Above;
      case [right, below, left, above] if(below): Below;
      case _: Around;
    }
  }
}
import h2d.Object;

class Wall extends Entity {

  public function new(args : {
    parent : Object,
    x : Float,
    y : Float,
    width : Float,
    height : Float
  }) {
    super(args.parent);

    x = args.x;
    y = args.y;
    
    Useful.assert(args.width >= 0, "args.width must be positive");
    Useful.assert(args.height >= 0, "args.height must be positive");
    collider = new EntityCollider(this, args.width, args.height);
  }
}
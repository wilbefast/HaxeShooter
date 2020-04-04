import h2d.Object;

class Entity extends h2d.Object {

  // ------------------------------------------------------------
  // STATIC METHODS
  // ------------------------------------------------------------

  private static var all : Array<Entity>;

  public static function updateAll(dt : Float) : Void {
    for(i in 0 ... all.length) {
      all[i].update(dt);
    }
  }

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  public var speed = new h3d.Vector(0, 0, 0);
  public var maxSpeed : Float = Math.POSITIVE_INFINITY;
  public var friction : Float = 0.0;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    s2d : h2d.Scene
  }) {
    Useful.assert(args.s2d != null, 'args.s2d must be non-null');
    super(args.s2d);

    // add to the list of all the entities
    if(all == null) {
      all = new Array<Entity>();
    }
    all.push(this);
  }

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function update(dt : Float) : Void {
    // speed
    x += speed.x;
    y += speed.y;

    // friction
    Useful.assert(friction >= 0, "friction cannot be negative");
    if (friction != 0) {
      Useful.assert(friction <= 1, "friction cannot be above 100%");
      //speed.scale3(Math.pow(1 - friction, dt));
    }

    // collision checking
    // TODO
  }
}
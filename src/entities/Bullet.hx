using h3d.Vector;

class Bullet extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var RADIUS = 12.0;
  private static inline var SPEED = 2000.0;
  private static inline var LIFESPAN = 1.0;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var direction = new Vector(0, 0, 0);
  private var life = LIFESPAN;
  private var bitmap : h2d.Bitmap;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(source : Entity, direction : Vector) {
    super(source.parent);

    // visual
    var tile = h2d.Tile.fromColor(0xFFFF00, 1, 1);
    tile.dx = tile.dy = -0.5;
    bitmap = new h2d.Bitmap(tile, this);
    bitmap.setScale(2*RADIUS);
    
    // speed
    x = source.x;
    y = source.y;
    speed.load(direction);
    speed.scale3(SPEED);

    // collisions
    collider = new Collider(this, RADIUS);

    // shake screen
    State.addShake(1);
    State.addFreeze(0.03);
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    bitmap.setScale(RADIUS * Useful.lerp(4, 2, 30*(1 - life)));
    if((life -= dt) <= 0.0) {
      purge = true;
    }

    super.update(dt);
  }
}
import h3d.Vector;

class Bullet extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var RADIUS = 24.0;
  private static inline var SPRITE_DIAMETER = RADIUS*1.2;
  private static inline var SPEED = 2000.0;
  private static inline var LIFESPAN = 1.0;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var direction = new Vector(0, 0, 0);
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
    bitmap.setScale(SPRITE_DIAMETER);
    
    // speed
    x = source.x;
    y = source.y;
    speed.load(direction);
    speed.scale3(SPEED);

    // collisions
    collider = new EntityCollider(this, RADIUS);

    // muzzle flash
    var flash = new MuzzleFlash(this);
    flash.x += direction.x * SPRITE_DIAMETER;
    flash.y += direction.y * SPRITE_DIAMETER;
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    // movement
    super.update(dt);
  }

  // ------------------------------------------------------------
  // COLLISIONS
  // ------------------------------------------------------------

  public override function onCollision(other : Entity, dt : Float) : Void {
    if(Std.is(other, Wall)) {
      // snap to contact with walls
      snapFromCollisionWith(other);
      this.explode();
    }
  }

  // ------------------------------------------------------------
  // DESTRUCTION
  // ------------------------------------------------------------

  public function explode() {
    new BulletImpact(this);
    purge = true;
  }
}
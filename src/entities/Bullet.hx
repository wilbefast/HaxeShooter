import h3d.Vector;

class Bullet extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var RADIUS = 18.0;
  private static inline var SPRITE_DIAMETER = RADIUS*1.5;
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
    collider = new Collider(this, RADIUS);

    // muzzle flash
    var flash = new MuzzleFlash(this);
    flash.x += direction.x * SPRITE_DIAMETER;
    flash.y += direction.y * SPRITE_DIAMETER;
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    // explode on horizontal walls
    var newX = x + speed.x*dt;
    if(newX < 0) {
      x = 0;
      explode();
    }
    else if(newX > State.WIDTH) {
      x = State.WIDTH;
      explode();
    }

    // explode on vertical walls
    var newY = y + speed.y*dt;
    if(newY < 0) {
      y = 0;
      explode();
    }
    else if(newY > State.HEIGHT) {
      y = State.HEIGHT;
      explode();
    }
    
    // muzzle flash
        
    // movement
    super.update(dt);
  }

  // ------------------------------------------------------------
  // DESTRUCTION
  // ------------------------------------------------------------

  public function explode() {
    new BulletImpact(this);
    purge = true;
  }
}
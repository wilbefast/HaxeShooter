using h3d.Vector;

class Bullet extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var RADIUS = 18.0;
  private static inline var SPRITE_DIAMETER = RADIUS*1.5;
  private static inline var EXPLOSION_DIAMETER = 4*SPRITE_DIAMETER;
  private static inline var SPEED = 2000.0;
  private static inline var LIFESPAN = 1.0;
  private static inline var EXPLOSION_DURATION = 0.2;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var direction = new Vector(0, 0, 0);
  private var timer = LIFESPAN;
  private var isExploding = false;
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

    // shake screen
    State.addShake(1);
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {

    if(isExploding) {
      // particle effect
      timer -= dt;
      if(timer <= 0) {
        purge = true;
      }
      else {
        var progress = 1 - timer/EXPLOSION_DURATION;
        bitmap.setScale(Useful.lerp(SPRITE_DIAMETER, EXPLOSION_DIAMETER, progress));
        bitmap.alpha = 1 - progress;
      }

      return;
    }

    if((timer -= dt) <= 0.0) {
      // timeout
      explode();
      return;
    }

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
    bitmap.setScale(Useful.lerp(EXPLOSION_DIAMETER, SPRITE_DIAMETER, 30*(1 - timer)));
        
    // movement
    super.update(dt);
  }

  // ------------------------------------------------------------
  // DESTRUCTION
  // ------------------------------------------------------------

  public function explode() {
    if(isExploding) {
      return;
    }
    isExploding = true;
    timer = EXPLOSION_DURATION;
  }
}
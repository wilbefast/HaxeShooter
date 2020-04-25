import h3d.Vector;

class Bullet extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var RADIUS = 24.0;
  private static inline var SPEED = 2000.0;
  private static inline var LIFESPAN = 1.0;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var direction = new Vector(0, 0, 0);
  private var anim : h2d.Anim;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(source : Entity, direction : Vector) {
    super(source.parent);

    var atlas = hxd.Res.foreground;
    var bullet = atlas.getAnim("bullet");
    Useful.assert(bullet != null, "atlas must contain the 'bullet'");
    anim = new h2d.Anim(bullet, this);
    for(t in anim.frames) {
      t.dx = t.dy = -24;
    }
    anim.speed = 10;
    anim.rotate(Math.atan2(direction.x, -direction.y) - Math.PI*0.5);

    // speed
    x = source.x;
    y = source.y;
    speed.load(direction);
    speed.scale3(SPEED);

    // collisions
    collider = new EntityCollider(this, RADIUS);

    // muzzle flash
    var flash = new MuzzleFlash(this);
    flash.x += direction.x * RADIUS;
    flash.y += direction.y * RADIUS;
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
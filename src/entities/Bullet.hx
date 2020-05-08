import h3d.Vector;

class Bullet extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var RADIUS = 28.0;
  private static inline var INITIAL_SPEED = 500.0;
  private static inline var MAX_SPEED = 2000.0;
  private static inline var TRAIL_PERIOD = 0.01;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var direction = new Vector(0, 0, 0);
  private var anim : h2d.Anim;

  private var trailTimer : Float;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(source : Entity, direction : Vector) {
    super(cast(source.parent, h2d.Layers));

    // trail
    trailTimer = 0;

    // speed
    maxSpeed = MAX_SPEED;
    x = source.x;
    y = source.y;
    speed.load(direction);
    speed.scale3(INITIAL_SPEED);

    // collisions
    collider = new EntityCollider(this, RADIUS);

    // muzzle flash
    var flash = new MuzzleFlash(this);
    flash.x += direction.x * RADIUS;
    flash.y += direction.y * RADIUS;

    // visuals
    var atlas = hxd.Res.foreground;
    var shadow = atlas.getAnim("bullet_shadow");
    Useful.assert(shadow != null, "atlas must contain the 'bullet_shadow'");
    var animShadow = new h2d.Anim(shadow, this);
    animShadow.x = -12;
    animShadow.y = 32;
    if(Math.abs(speed.x) > 1.7*Math.abs(speed.y)) {
      var frames = atlas.getAnim("bullet_side");
      Useful.assert(frames != null, "atlas must contain the 'bullet_side'");
      var anim = new h2d.Anim(frames, this);
      anim.x = -16;
      anim.y = 16;
      if(speed.x < 0) {
        anim.scaleX = -1;
      }
    }
    else {
      if(speed.y < 0) {
        var frames = atlas.getAnim("bullet_up");
        Useful.assert(frames != null, "atlas must contain the 'bullet_up'");
        var anim = new h2d.Anim(frames, this);
        anim.x = -16;
        anim.y = 16;
      }
      else {
        var frames = atlas.getAnim("bullet_down");
        Useful.assert(frames != null, "atlas must contain the 'bullet_down'");
        var anim = new h2d.Anim(frames, this);
        anim.x = -16;
        anim.y = 16;
      }
    }
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    // movement
    super.update(dt);

    // trail
    trailTimer -= dt;
    if(trailTimer < 0) {
      var overlap = -trailTimer/TRAIL_PERIOD;
      var endX = x;
      var endY = y;
      
      for(i in 0 ... Math.floor(overlap)) {
        var k = cast(i, Float) / overlap;
        x = Useful.lerp(prevX, endX, k);
        y = Useful.lerp(prevY, endY, k);
        var trail = new BulletTrail(this);
        trailTimer += TRAIL_PERIOD;
      }

      x = endX;
      y = endY;
    }

    // accelerate
    speed.scale3(1 + 2*dt);
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
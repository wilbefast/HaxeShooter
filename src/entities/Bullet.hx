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

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(source : Entity, direction : Vector) {
    super(source.parent);

    // visual
    var g = new h2d.Graphics(this);
		g.beginFill(0xFFFF00);
    g.drawRect(-RADIUS, -RADIUS, RADIUS*2, RADIUS*2);
    
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
    if((life -= dt) <= 0.0) {
      purge = true;
    }

    super.update(dt);
  }
}
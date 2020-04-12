using h3d.Vector;

class Zombie extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  // collisions
  private static inline var SIZE = 32;

  // physics
  private static inline var HIGH_FRICTION = 8000.0;
  private static inline var LOW_FRICTION = 0.003;
  private static inline var ACCELERATION = 1.6;
  private static inline var MAX_SPEED = 8;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var target : Entity;
  private var moveDirection = new Vector(0, 0, 0);

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    scene : h2d.Scene
  }) {
    super(args.scene);
    
    maxSpeed = MAX_SPEED;
    friction = HIGH_FRICTION;

    var g = new h2d.Graphics(this);
		g.beginFill(0x00FF00);
    g.drawRect(-SIZE/2, -SIZE/2, SIZE, SIZE);

    target = Entity.getFirst(function(entity) {
      return Std.is(entity, Avatar);
    });
    Useful.assert(target != null, "There must be an avatar");
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    // character movement
    moveDirection.set(target.x - x, target.y - y);
    
    var norm = moveDirection.length();
    if(norm < SIZE) {
      moveDirection.set(0, 0, 0);
      friction = HIGH_FRICTION;
    }
    else {
      moveDirection.scale3(ACCELERATION / norm);
      friction = LOW_FRICTION;
    }
    
    speed = speed.add(moveDirection);

    super.update(dt);
  }
}
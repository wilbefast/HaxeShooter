using h3d.Vector;

class Zombie extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  // collisions
  private static inline var RADIUS = 16;

  // physics
  private static inline var HIGH_FRICTION = 8000.0;
  private static inline var LOW_FRICTION = 0.003;
  private static inline var ACCELERATION = 1.6;
  private static inline var MAX_SPEED = 8;

  // combat 
  private static inline var MAX_HITPOINTS = 100;
  private static inline var BULLET_DAMAGE = 25;
  private static inline var BULLET_KNOCKBACK = 150;
  private static inline var BULLET_STUN_DURATION = 0.7;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var target : Entity;
  private var moveDirection = new Vector(0, 0, 0);
  private var hitpoints : Int = MAX_HITPOINTS;
  private var stunDuration : Float = 0.0;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    scene : h2d.Scene
  }) {
    super(args.scene);
    
    maxSpeed = MAX_SPEED;
    friction = HIGH_FRICTION;

    collider = new Collider(this, RADIUS);

    var g = new h2d.Graphics(this);
		g.beginFill(0x00FF00);
    g.drawRect(-RADIUS, -RADIUS, RADIUS*2, RADIUS*2);

    target = Entity.getFirst(function(entity) {
      return Std.is(entity, Avatar);
    });
    Useful.assert(target != null, "There must be an avatar");
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    if(stunDuration > 0) {
      stunDuration -= dt;
      friction = HIGH_FRICTION;
    }
    else {
      // character movement
      moveDirection.set(target.x - x, target.y - y);
      
      var norm = moveDirection.length();
      if(norm < RADIUS) {
        moveDirection.set(0, 0, 0);
        friction = HIGH_FRICTION;
      }
      else {
        moveDirection.scale3(ACCELERATION / norm);
        friction = LOW_FRICTION;
      }
      
      speed = speed.add(moveDirection);
    }

    super.update(dt);
  }

  // ------------------------------------------------------------
  // COLLISIONS
  // ------------------------------------------------------------

  public override function onCollision(other : Entity, dt : Float) : Void {
    if(Std.is(other, Bullet)) {
      // the bullet is destroyed
      other.purge = true;

      // take damage
      hitpoints -= BULLET_DAMAGE;
      if(hitpoints <= 0) {
        this.purge = true;
      }
      else {
        // stun
        stunDuration = BULLET_STUN_DURATION;

        // knock-back
        moveDirection.set(x - other.x, y - other.y);
        moveDirection.scale3(BULLET_KNOCKBACK);
        moveDirection.add(other.speed);

        speed = speed.add(moveDirection);
      }
    }
  }
}
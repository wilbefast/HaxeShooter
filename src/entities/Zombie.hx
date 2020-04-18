import js.html.Gamepad;
import h3d.Vector;

class Zombie extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  // collisions
  private static inline var RADIUS = 16;
  private static inline var COLLISION_STUN_DURATION = 0.2;
  private static inline var COLLISION_KNOCKBACK = 200;
  private static inline var MAX_REPULSION = 0.7;
  private static inline var REPULSION_RANGE = RADIUS*6;

  // movement
  private static inline var HIGH_FRICTION = 2000.0;
  private static inline var LOW_FRICTION = 0.01;
  private static inline var ACCELERATION = 1000.0;
  private static inline var MAX_SPEED = 300;

  // combat 
  private static inline var MAX_HITPOINTS = 100;
  private static inline var BULLET_DAMAGE = 25;
  private static inline var BULLET_KNOCKBACK = 150;
  private static inline var BULLET_STUN_DURATION = 0.4;


  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var target : Avatar;
  private var moveDirection = new Vector(0, 0, 0);
  private var hitpoints : Int = MAX_HITPOINTS;
  private var stunDuration : Float = 0.0;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    parent : h2d.Object
  }) {
    super(args.parent);
    
    maxSpeed = MAX_SPEED;
    friction = HIGH_FRICTION;

    collider = new Collider(this, RADIUS);

    var tile = h2d.Tile.fromColor(0x00FF00, 1, 1);
    tile.dx = tile.dy = -0.5;
    var bitmap = new h2d.Bitmap(tile, this);
    bitmap.setScale(2*RADIUS);

    var label = new h2d.Text(hxd.res.DefaultFont.get(), this);
    label.text = "X_X";
    label.textAlign = Center;
    label.color = new Vector(0, 0, 0);
    label.y = -8;

    target = cast(Entity.getFirst(function(entity) {
      return Std.is(entity, Avatar);
    }), Avatar);
    Useful.assert(target != null, 'There must be an avatar');
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    if(stunDuration > 0) {
      // recover from stun
      stunDuration -= dt;
      friction = HIGH_FRICTION;
    }
    else {
      // pursue target
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

      // query other objects present in the scene
      Entity.map(function(other : Entity) {
        if(Std.is(other, Avatar)) {
          // TODO
          // select a new target
        }
        if(Std.is(other, Zombie)) {
          // repulse from other zombies
          moveDirection.set(x - other.x, y - other.y);
          var norm = moveDirection.length();
          if(norm <= REPULSION_RANGE) {
            var repulsion = 1 - (norm / REPULSION_RANGE);
            moveDirection.scale3(repulsion * repulsion * MAX_REPULSION);
            speed = speed.add(moveDirection);
          }
        }
        return false;
      });
    }

    super.update(dt);
  }

  // ------------------------------------------------------------
  // COLLISIONS
  // ------------------------------------------------------------

  public override function onCollision(other : Entity, dt : Float) : Void {
    if(Std.is(other, Bullet)) {
      // the bullet is destroyed
      cast(other, Bullet).explode();

      // take damage
      hitpoints -= BULLET_DAMAGE;
      if(hitpoints <= 0) {
        // add score
        target.addScore(1);
        
        // die
        new ZombieGibs(this);
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
    else if(Std.is(other, Zombie)) {
      // stun
      stunDuration = COLLISION_STUN_DURATION;

      // knock-back
      moveDirection.set(x - other.x, y - other.y);
      moveDirection.scale3(COLLISION_KNOCKBACK);
      speed = speed.add(moveDirection);
    }
    else if(Std.is(other, Avatar)) {
      if(stunDuration <= 0) {
        // game over!
        State.setCurrent("score");
        hxd.Res.gameover.play(false, 0.1);
      }
    }
  }
}
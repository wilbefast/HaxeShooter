import js.html.Gamepad;
import h3d.Vector;

class Zombie extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  // collisions
  private static inline var RADIUS = 16;
  private static inline var COLLISION_STUN_DURATION = 0.1;
  private static inline var ZOMBIE_COLLISION_KNOCKBACK = 200;
  private static inline var AVATAR_COLLISION_KNOCKBACK = 10;
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
  private static inline var BULLET_STUN_DURATION = 0.2;


  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var target : Avatar;
  private var moveDirection = new Vector(0, 0, 0);
  private var hitpoints : Int = MAX_HITPOINTS;
  private var stunDuration : Float = 0.0;
  private var hasDamagedMe = new Map<Entity, Bool>();

  // visuals
  private var currentAnim : h2d.Anim;
  private var animUp : h2d.Anim;
  private var animDown : h2d.Anim;
  private var animLeft : h2d.Anim;
  private var animRight : h2d.Anim;
  private var animShadow : h2d.Anim;
  private var animStunned : h2d.Anim;

  // events
  public var onDeath : Void -> Void;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    parent : h2d.Layers,
    x : Float,
    y : Float
  }) {
    super(args.parent);
    x = args.x;
    y = args.y;
    
    // physics
    maxSpeed = MAX_SPEED;
    friction = HIGH_FRICTION;
    collider = new EntityCollider(this, RADIUS);

    // visuals
    var atlas = hxd.Res.foreground;
    var shadow = atlas.getAnim("zombie_shadow");
    Useful.assert(shadow != null, "atlas must contain the 'zombie_shadow'");
    animShadow = new h2d.Anim(shadow, this);
    animShadow.x = -24;
    animShadow.y = 30;
    var down = atlas.getAnim("zombie_down");
    Useful.assert(down != null, "atlas must contain the 'zombie_down'");
    animDown = new h2d.Anim(down, this);
    animDown.x = -32;
    animDown.y = 24;
    currentAnim = animDown;
    var up = atlas.getAnim("zombie_up");
    Useful.assert(up != null, "atlas must contain the 'zombie_up'");
    animUp = new h2d.Anim(up, this);
    animUp.x = -32;
    animUp.y = 24;
    animUp.visible = false;
    var side = atlas.getAnim("zombie_side");
    Useful.assert(side != null, "atlas must contain the 'zombie_side'");
    animLeft = new h2d.Anim(side, this);
    animLeft.x = 32;
    animLeft.y = 24;
    animLeft.scaleX = -1;
    animLeft.visible = false;
    animRight = new h2d.Anim(side, this);
    animRight.x = -32;
    animRight.y = 24;
    animRight.visible = false;
    var stunned = atlas.getAnim("zombie_stunned");
    Useful.assert(stunned != null, "atlas must contain the 'zombie_stunned'");
    animStunned = new h2d.Anim(stunned, this);
    animStunned.x = -32;
    animStunned.y = 24;
    animStunned.visible = false;

    // artificial intelligence
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

      // choose animation
      if(Math.abs(moveDirection.x) > Math.abs(moveDirection.y)) {
        if(moveDirection.x < 0) {
          setAnimation(animLeft);
        }
        else {
          setAnimation(animRight);
        }
      }
      else {
        if(moveDirection.y < 0) {
          setAnimation(animUp);
        }
        else {
          setAnimation(animDown);
        }
      }

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
  // VISUALS
  // ------------------------------------------------------------

  private function setAnimation(anim : h2d.Anim) {
    currentAnim.visible = false;
    anim.visible = true;
    currentAnim = anim;
    currentAnim.speed = 5;
  }

  // ------------------------------------------------------------
  // COLLISIONS
  // ------------------------------------------------------------

  public override function onCollision(other : Entity, dt : Float) : Void {
    if(Std.is(other, BulletImpact)) {
      if(!hasDamagedMe[other]) {
        hasDamagedMe[other] = true;

        // knock-back self
        moveDirection.set(x - other.x, y - other.y);
        moveDirection.scale3(AVATAR_COLLISION_KNOCKBACK);
        speed = speed.add(moveDirection);

        // stun
        stunDuration = BULLET_STUN_DURATION;
        setAnimation(animStunned);

        // take damage
        hitpoints -= BULLET_DAMAGE;
        if(hitpoints <= 0) {
          // add score
          target.addScore(1);
          
          // die
          if (onDeath != null) {
            onDeath();
          }
          new ZombieGibs(this);
          this.purge = true;
        }
      }
    }
    else if(Std.is(other, Bullet)) {
      // the bullet is destroyed
      cast(other, Bullet).explode();

      // knock-back
      moveDirection.set(x - other.x, y - other.y);
      moveDirection.scale3(BULLET_KNOCKBACK);
      moveDirection.add(other.speed);
      speed = speed.add(moveDirection);
    }
    else if(Std.is(other, Zombie)) {
      // stun
      stunDuration = COLLISION_STUN_DURATION;

      // knock-back
      moveDirection.set(x - other.x, y - other.y);
      moveDirection.scale3(ZOMBIE_COLLISION_KNOCKBACK);
      speed = speed.add(moveDirection);
    }
    else if(Std.is(other, Avatar)) {
      if(stunDuration <= 0) {
        if(speed.lengthSq() > other.speed.lengthSq()) {
          // game over!
          State.setCurrent("score");
          hxd.Res.gameover.play(false, 0.1);
        }
        else {
          // slow other
          other.speed.scale3(0.4);

          // knock-back other
          moveDirection.set(other.x - x, other.y - y);
          moveDirection.scale3(AVATAR_COLLISION_KNOCKBACK);
          other.speed = other.speed.add(moveDirection);
        }
      }

      // knock-back self
      moveDirection.set(x - other.x, y - other.y);
      moveDirection.scale3(ZOMBIE_COLLISION_KNOCKBACK);
      speed = speed.add(moveDirection).add(other.speed);

      // stun
      stunDuration = COLLISION_STUN_DURATION;
    }
  }
}
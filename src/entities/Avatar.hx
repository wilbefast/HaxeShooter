import h2d.col.Circle;
import EntityCollider.HeapsCollider;
import hxd.Key;
import h3d.Vector;

enum Color {
  Red;
  Green;
  Blue;
  Rgb(r:Int, g:Int, b:Int);
}

class Avatar extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  // collisions
  private static inline var RADIUS = 18;

  // movement
  private static inline var HIGH_FRICTION = 5000.0;
  private static inline var LOW_FRICTION = 10;
  private static inline var ACCELERATION = 5000.0;
  private static inline var MAX_SPEED = 1000.0;

  // weapon
  private static inline var TIME_BETWEEN_BULLETS = 0.1;
  private static inline var RECOIL = 100.0;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  // control
  private var moveDirection = new Vector(0, 0, 0);

  // weapon
  private var weaponTarget = new Vector(0, 0, 0);
  private var weaponDirection = new Vector(0, 0, 0);
  private var reloadTime = 0.0;

  // score
  public var score(default, null) : Int = 0;
  private var scoreLabel : h2d.Text;

  // visuals
  private var currentAnim : h2d.Anim;
  private var animUp : h2d.Anim;
  private var animDown : h2d.Anim;
  private var animLeft : h2d.Anim;
  private var animRight : h2d.Anim;
  private var animShadow : h2d.Anim;

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
    var shadow = atlas.getAnim("player_shadow");
    Useful.assert(shadow != null, "atlas must contain the 'player_shadow'");
    animShadow = new h2d.Anim(shadow, this);
    animShadow.x = -16;
    animShadow.y = 48;
    var down = atlas.getAnim("player_down");
    Useful.assert(down != null, "atlas must contain the 'player_down'");
    animDown = new h2d.Anim(down, this);
    animDown.x = -32;
    animDown.y = 24;
    currentAnim = animDown;
    var up = atlas.getAnim("player_up");
    Useful.assert(up != null, "atlas must contain the 'player_up'");
    animUp = new h2d.Anim(up, this);
    animUp.x = -32;
    animUp.y = 24;
    animUp.visible = false;
    var side = atlas.getAnim("player_side");
    Useful.assert(side != null, "atlas must contain the 'player_side'");
    animLeft = new h2d.Anim(side, this);
    animLeft.x = 32;
    animLeft.y = 24;
    animLeft.scaleX = -1;
    animLeft.visible = false;
    animRight = new h2d.Anim(side, this);
    animRight.x = -32;
    animRight.y = 24;
    animRight.visible = false;

    // score
    scoreLabel = new h2d.Text(State.smallFont, args.parent);
    scoreLabel.text = 'score: $score';
    scoreLabel.textAlign = Left;
    scoreLabel.color = new Vector(1, 1, 1);
    scoreLabel.x = 32;
    scoreLabel.y = 32;
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    // check whether mouse is down
    var isFiring = Key.isDown(Key.MOUSE_LEFT);

    // character weapon
    reloadTime = Math.max(0, reloadTime - dt);
    if(isFiring && reloadTime <= 0) {
      // aim and fire
      weaponDirection.load(weaponTarget);
      weaponDirection.x -= x;
      weaponDirection.y -= y;
      weaponDirection.normalize();
      var bullet = new Bullet(this, weaponDirection);

      // recoil
      weaponDirection.scale3(RECOIL);
      speed = speed.sub(weaponDirection);

      // reload time
      reloadTime = TIME_BETWEEN_BULLETS;
    }

    // character desired direction
    moveDirection.set(0, 0);
    if (Key.isDown(Key.LEFT) ||  Key.isDown(Key.A) || Key.isDown(Key.Q)) {
      moveDirection.x -= 1;
    }
    if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) {
      moveDirection.x += 1;
    }
    if (Key.isDown(Key.UP) || Key.isDown(Key.W) || Key.isDown(Key.Z)) {
      moveDirection.y -= 1;
    }
    if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) {
      moveDirection.y += 1;
    }

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
    
    // character acceleration
    var norm = moveDirection.length();
    if(norm < 0.01) {
      moveDirection.set(0, 0, 0);
      friction = HIGH_FRICTION;
    }
    else {
      moveDirection.scale3(ACCELERATION / norm * dt);
      friction = LOW_FRICTION;
    }

    // update speed
    speed = speed.add(moveDirection);

    // update position
    super.update(dt); 
  }

  // ------------------------------------------------------------
  // VISUALS
  // ------------------------------------------------------------

  private function setAnimation(anim : h2d.Anim) {
    currentAnim.visible = false;
    anim.visible = true;
    currentAnim = anim;
    currentAnim.speed = 7;
  }

  // ------------------------------------------------------------
  // FIRING WEAPONS
  // ------------------------------------------------------------

  public function setTarget(x : Float, y : Float) : Void {
    weaponTarget.set(x, y);
  }

  // ------------------------------------------------------------
  // COLLISIONS
  // ------------------------------------------------------------

  public override function onCollision(other : Entity, dt : Float) : Void {
    if(Std.is(other, Wall)) {
      // bounce off walls
      var wall = cast(other, Wall);
      snapFromCollisionWith(wall);
      switch(wall.getPositionRelativeTo(this)) {
        case Left | Right:
          speed.x *= -1;
        case Above | Below:
          speed.y *= -1;
        case _:
      }
    }
  }

  // ------------------------------------------------------------
  // SCORE
  // ------------------------------------------------------------

  public function addScore(amount : Int) {
    score += amount;
    scoreLabel.text = 'score: $score';
  }

  public override function onPurge() {
    scoreLabel.remove();
    super.onPurge();
  }
}
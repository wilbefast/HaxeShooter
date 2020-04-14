using hxd.Key;
using h3d.Vector;

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
  private var isFiring = false;
  private var reloadTime = 0.0;

  // score
  private var score : Int = 0;
  private var scoreLabel : h2d.Text;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    scene : h2d.Object
  }) {
    super(args.scene);

    // physics
    maxSpeed = MAX_SPEED;
    friction = HIGH_FRICTION;
    collider = new Collider(this, RADIUS);

    // visuals
    var g = new h2d.Graphics(this);
		g.beginFill(0xFFFFFF);
		g.drawRect(-RADIUS, -RADIUS, RADIUS*2, RADIUS*2);
    var label = new h2d.Text(hxd.res.DefaultFont.get(), this);
    label.text = "0_0";
    label.textAlign = Center;
    label.color = new Vector(0, 0, 0);
    label.y = -8;

    // score
    GameOver.score = score = 0;
    scoreLabel = new h2d.Text(hxd.res.DefaultFont.get(), args.scene);
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

    // character movement
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
    
    var norm = moveDirection.length();
    if(norm < 0.01) {
      moveDirection.set(0, 0, 0);
      friction = HIGH_FRICTION;
    }
    else {
      moveDirection.scale3(ACCELERATION / norm * dt);
      friction = LOW_FRICTION;
    }
    
    speed = speed.add(moveDirection);
    super.update(dt); 
  }

  // ------------------------------------------------------------
  // FIRING WEAPONS
  // ------------------------------------------------------------

  public function setFiring(firing : Bool) : Void {
    isFiring = firing;
  }

  public function setTarget(x : Float, y : Float) : Void {
    weaponTarget.set(x, y);
  }

  // ------------------------------------------------------------
  // COLLISIONS
  // ------------------------------------------------------------

  public override function onCollision(other : Entity, dt : Float) : Void {
    // TODO
  }

  // ------------------------------------------------------------
  // SCORE
  // ------------------------------------------------------------

  public function addScore(amount : Int) {
    score += amount;
    scoreLabel.text = 'score: $score';
    GameOver.score = score;
  }

  public override function onPurge() {
    scoreLabel.remove();
    super.onPurge();
  }
}
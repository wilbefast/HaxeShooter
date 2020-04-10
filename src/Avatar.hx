using hxd.Key;
using h3d.Vector;

class Avatar extends Entity {

  // ------------------------------------------------------------
  // CONSTANTS
  // ------------------------------------------------------------

  private static inline var SIZE = 32;
  private static inline var HIGH_FRICTION = 8000.0;
  private static inline var LOW_FRICTION = 0.003;
  private static inline var ACCELERATION = 2.1;

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  private var moveDirection = new Vector(0, 0, 0);
  private var weaponTarget = new Vector(0, 0, 0);
  private var weaponDirection = new Vector(0, 0, 0);
  private var isFiring = false;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(args : {
    s2d : h2d.Scene
  }) {
    super(args.s2d);
    maxSpeed = 10;
    friction = HIGH_FRICTION;

    var g = new h2d.Graphics(this);
		g.beginFill(0xFFFFFF);
		g.drawRect(-SIZE/2, -SIZE/2, SIZE, SIZE);

    var label = new h2d.Text(hxd.res.DefaultFont.get(), this);
    label.text = "hello world";
    label.textAlign = Center;
    label.color = new Vector(1, 0, 0);
    label.y = -32;
  }

  // ------------------------------------------------------------
  // UPDATE LOOP
  // ------------------------------------------------------------

  public override function update(dt : Float) {
    // character weapon
    if(isFiring) {
      weaponDirection.load(weaponTarget);
      weaponDirection.x -= x;
      weaponDirection.y -= y;
      weaponDirection.normalize();
      var bullet = new Bullet(this, weaponDirection);
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
      moveDirection.scale3(ACCELERATION / norm);
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
}
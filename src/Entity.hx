import h2d.Object;
import h3d.Vector;

class Entity extends h2d.Object {

  // ------------------------------------------------------------
  // STATIC METHODS
  // ------------------------------------------------------------

  private static var all : Array<Entity>;

  public static function updateAll(dt : Float) : Void {
    var i = 0;
    while(i < all.length) {
      var current = all[i];
      if(current.purge) {
        current.onPurge();
        all[i] = all[all.length - 1];
        all.pop();
      }
      else {
        current.update(dt);
        i++;
      }
    }
  }

  public static function getFirst(?suchThat : Entity -> Bool) : Entity {
    for(current in all) {
      if(!current.purge && (suchThat == null || suchThat(current))) {
        return current;
      }
    }
    return null;
  }

  public static function map(f : Entity -> Bool) : Entity {
    for(current in all) {
      if(!current.purge && f(current)) {
        return current;
      }
    }
    return null;
  };

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  public var speed = new Vector(0, 0, 0);
  public var maxSpeed : Float = Math.POSITIVE_INFINITY;
  public var friction : Float = 0.0;
  
  private var collider : Collider = null;

  public var purge : Bool = false;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(scene : h2d.Object) {
    Useful.assert(scene != null, 'scene must be non-null');
    super(scene);

    // add to the list of all the entities
    if(all == null) {
      all = new Array<Entity>();
    }
    all.push(this);
  }


  // ------------------------------------------------------------
  // EVENTS
  // ------------------------------------------------------------

  private function onPurge() : Void {
    remove();
    if(collider != null) {
      collider.purge = true;
    }
  }

  public function onCollision(other : Entity, dt : Float) : Void {
    // override this
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------

  public function update(dt : Float) : Void {
    // calculate speed
    var norm = speed.length();
    var newNorm = norm;

    // friction
    Useful.assert(friction >= 0, "friction cannot be negative");
    if (friction != 0) {
      newNorm /= Math.pow(1 + friction, dt);
    }

    // terminal velocity
    if (norm > maxSpeed) {
      newNorm = maxSpeed;
    }

    // update speed
    if (norm != newNorm) {
      speed.scale3(newNorm / norm);
    }

    // update position
    x += speed.x;
    y += speed.y;
  }
}
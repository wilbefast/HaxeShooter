import h3d.Vector;
import h2d.Object;

class Collider extends Object {

  // ------------------------------------------------------------
  // STATIC METHODS
  // ------------------------------------------------------------

  private static var all : Array<Collider>;

  public static function generateCollisions(dt : Float) : Void {
    if(all != null) {
      var i = 0;
      while(i < all.length) {
        var current = all[i];
        if(current.purge) {
          all[i] = all[all.length - 1];
          all.pop();
        }
        else {
          for(j in i+1 ... all.length) {
            var other = all[j];
            if(current.isCollidingWith(other)) {
              var currentEntity = current.entity;
              var otherEntity = other.entity;
              currentEntity.onCollision(otherEntity, dt);
              otherEntity.onCollision(currentEntity, dt);
            }
          }
          i++;
        }
      }
    }
  }

  // ------------------------------------------------------------
  // ATTRIBUTES
  // ------------------------------------------------------------

  public var position = new Vector(0, 0, 0);
  public var purge : Bool = false;
  
  private var radius: Float = 0.0;
  private var entity : Entity;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(entity : Entity, radius : Float) {
    // attach events
    Useful.assert(entity != null, 'An entity must be specified');
    this.entity = entity;
    super(entity);
    
    // setup geometry
    Useful.assert(radius > 0, 'Radius must be strictly positive');
    this.radius = radius;

    // add to the list of all the colliders
    if(all == null) {
      all = new Array<Collider>();
    }
    all.push(this);
  }

  // ------------------------------------------------------------
  // QUERY
  // ------------------------------------------------------------

  public inline function isCollidingWith(other : Collider) : Bool {
    if(purge || other.purge) {
      return false;
    }
    
    position.set(entity.x, entity.y);
    other.position.set(other.entity.x, other.entity.y);
    var radius2 = radius + other.radius;
    radius2 *= radius2;
    return position.distanceSq(other.position) <= radius2;
  }    
}
import h3d.Vector;
import h2d.Object;

enum HeapsCollider {
  Circle(circle : h2d.col.Circle);
  Bounds(bounds : h2d.col.Bounds);
  Point(point : h2d.col.Point);
}

class EntityCollider {

  // ------------------------------------------------------------
  // STATIC METHODS
  // ------------------------------------------------------------

  private static var all : Array<EntityCollider>;

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

  public var purge : Bool = false;
  private var entity : Entity;
  private var heapsCollider : HeapsCollider;

  // ------------------------------------------------------------
  // CONSTRUCTOR
  // ------------------------------------------------------------

  public function new(entity : Entity, ?w : Float = 0, ?h : Float = 0){
    // attach events
    Useful.assert(entity != null, 'An entity must be specified');
    this.entity = entity;
    
    // setup geometry
    Useful.assert(w >= 0, 'The value of width must be positive');
    Useful.assert(h >= 0, 'The value of height must be positive');
    heapsCollider = switch(w) {
      case 0: 
        Point(new h2d.col.Point(entity.x, entity.y));
      case _: 
        switch(h) {
          case 0: 
            Circle(new h2d.col.Circle(entity.x, entity.y, w));
          case _: 
            Bounds(h2d.col.Bounds.fromValues(entity.x, entity.y, w, h));
        }
    }

    // add to the list of all the colliders
    if(all == null) {
      all = new Array<EntityCollider>();
    }
    all.push(this);
  }

  // ------------------------------------------------------------
  // MODIFICATION
  // ------------------------------------------------------------

  public inline function updatePosition() {
    switch(heapsCollider) {
      case Circle(c): c.x = entity.x; c.y = entity.y;
      case Bounds(b): b.x = entity.x; b.y = entity.y;
      case Point(p): p.x = entity.x; p.y = entity.y;
    }
  }

  // ------------------------------------------------------------
  // QUERY
  // ------------------------------------------------------------

  public inline function getPosition() : { x : Float, y : Float } {
    return switch(heapsCollider) {
      case Circle(c): {x : c.x, y : c.y};
      case Bounds(b): {x : b.x, y : b.y};
      case Point(p): {x : p.x, y : p.y};
    }
  }

  public function wouldBeCollidingWith(other : EntityCollider, x : Float, y : Float) : Bool {
    var originalX = entity.x;
    var originalY = entity.y;
    entity.x = x;
    entity.y = y;
    updatePosition();
    var result = isCollidingWith(other);
    entity.x = originalX;
    entity.y = originalY;
    return result;
  }

  public inline function isCollidingWith(other : EntityCollider) : Bool {
    if(purge || other.purge) {
      return false;
    }
    
    return switch([heapsCollider, other.heapsCollider]) {
      case [Circle(c1), Circle(c2)]: c1.collideCircle(c2);
      case [Circle(c1), Bounds(b2)]: c1.collideBounds(b2);
      case [Circle(c1), Point(p2)]: c1.contains(p2);
      case [Bounds(b1), Circle(c2)]: c2.collideBounds(b1);
      case [Bounds(b1), Bounds(b2)]: b1.intersects(b2);
      case [Bounds(b1), Point(p2)]: b1.contains(p2);
      case [Point(p1), Circle(c2)]: c2.contains(p1);
      case [Point(p1), Bounds(b2)]: b2.contains(p1);
      case [Point(p1), Point(p2)]: p1.x == p2.x && p1.y == p2.y;

    }
  }   
}
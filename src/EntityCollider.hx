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

  public var position = new Vector(0, 0, 0);
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
  // QUERY
  // ------------------------------------------------------------

  public inline function isCollidingWith(other : EntityCollider) : Bool {
    if(purge || other.purge) {
      return false;
    }
    
    var otherEntity = other.entity;

    switch(heapsCollider) {
      case Circle(c1): 
        c1.x = entity.x;
        c1.y = entity.y;
        switch(other.heapsCollider) {
          case Circle(c2): 
            c2.x = otherEntity.x;
            c2.y = otherEntity.y;
            return c1.collideCircle(c2);
          case Bounds(b2): 
            b2.x = otherEntity.x;
            b2.y = otherEntity.y;
            return c1.collideBounds(b2);
          case Point(p2):
            p2.x = otherEntity.x;
            p2.y = otherEntity.y;
            return c1.contains(p2);
        }
      case Bounds(b1):
        b1.x = entity.x;
        b1.y = entity.y;
        switch(other.heapsCollider) {
          case Circle(c2): 
            c2.x = otherEntity.x;
            c2.y = otherEntity.y;
            return c2.collideBounds(b1);
          case Bounds(b2): 
            b2.x = otherEntity.x;
            b2.y = otherEntity.y;
            return b1.intersects(b2);
          case Point(p2):
            p2.x = otherEntity.x;
            p2.y = otherEntity.y;
            return b1.contains(p2);
        }
      case Point(p1):
        p1.x = entity.x;
        p1.y = entity.y;
        switch(other.heapsCollider) {
          case Circle(c2): 
            c2.x = otherEntity.x;
            c2.y = otherEntity.y;
            return c2.contains(p1);
          case Bounds(b2): 
            b2.x = otherEntity.x;
            b2.y = otherEntity.y;
            return b2.contains(p1);
          case Point(p2):
            p2.x = otherEntity.x;
            p2.y = otherEntity.y;
            return p1.x == p2.x && p1.y == p2.y;
        }
    }
  }   
}
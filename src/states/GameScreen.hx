import h2d.Layers;
import hxd.Cursor.CustomCursor;

class GameScreen extends State {

  private static inline var ZOMBIE_INITIAL_PERIOD = 1.5;
  private static inline var ZOMBIE_PERIOD_DECREASE = 0.05;
  private static inline var ZOMBIE_MINIMUM_PERIOD = 0.1;
  private static inline var ZOMBIE_DISTANCE = 50.0;
  private static inline var ZOMBIE_MAXIMUM = 30;

  private var zombiePeriod : Float;
  private var zombieTimer : Float;
  private var zombieMaximum : Int;
  private var zombieCount : Int;

  private var cursor : h2d.Object;

  private var avatar : Avatar;

  private var wallNorth : Wall;
  private var wallSouth : Wall;
  private var wallEast : Wall;
  private var wallWest : Wall;

  public override function new() {
    super({
      name : "game"
    });
  }

  public override function onEnter(previousState : State) {
    // reset score
    State.score = 0;

    // reset zombie timer
    zombiePeriod = ZOMBIE_INITIAL_PERIOD;
    zombieTimer = zombiePeriod;
    zombieMaximum = 1;
    zombieCount = 0;

    // create background
    var background = new h2d.Object();
    var backgroundTile = hxd.Res.concrete.toTile();
    backgroundTile.setSize(State.WIDTH, State.HEIGHT);
    var bitmap = new h2d.Bitmap(backgroundTile, this);
    bitmap.tileWrap = true;
    this.addChildAt(background, -1);

    // create walls
    wallNorth = new Wall({
      parent : this,
      x : 0,
      y : -State.HEIGHT,
      width : State.WIDTH,
      height : State.HEIGHT
    });
    wallSouth = new Wall({
      parent : this,
      x : 0,
      y : State.HEIGHT,
      width : State.WIDTH,
      height : State.HEIGHT
    });
    wallWest = new Wall({
      parent : this,
      x : -State.WIDTH,
      y : -State.HEIGHT,
      width : State.WIDTH,
      height : 3*State.HEIGHT
    });
    wallEast = new Wall({
      parent : this,
      x : State.WIDTH,
      y : -State.HEIGHT,
      width : State.WIDTH,
      height : 3*State.HEIGHT
    });

    // create entities
    avatar = new Avatar({
      parent : this,
      x : State.WIDTH / 2,
      y : State.HEIGHT / 2
    });

    // create cursor
    cursor = new h2d.Object();
    var atlas = hxd.Res.foreground;
    var crosshairTile = atlas.get("crosshair");
    Useful.assert(crosshairTile != null, "atlas must contain the 'crosshair'");
    var bitmap = new h2d.Bitmap(crosshairTile, cursor);
    bitmap.x = - 64;
    bitmap.y = 64;
    this.addChildAt(cursor, 1);
  }

  public override function onLeave(newState : State) {
    State.score = avatar.score;
    Entity.clear();
    removeChildren();
  }

  public override function onUpdate(dt : Float, mouseX : Float, mouseY : Float) {
    // read the mouse position
    cursor.x = mouseX;
    cursor.y = mouseY;
    avatar.setTarget(mouseX, mouseY);

    // tick the simulation
    Entity.updateAll(dt);
    EntityCollider.generateCollisions(dt);

    
    // spawn zombies periodically
    if(zombieCount < zombieMaximum) {
      zombieTimer -= dt;
      if(zombieTimer <= 0) {
        zombieCount++;
        zombieTimer = zombiePeriod;
        var angle = Math.random() * Math.PI * 2;
        var zombie = new Zombie({
          parent : this,
          x : State.WIDTH * (0.5 + Math.cos(angle)),
          y : State.HEIGHT * (0.5 + Math.sin(angle))
        });
        zombie.onDeath = function() {
          zombiePeriod = Math.max(ZOMBIE_MINIMUM_PERIOD, zombiePeriod*(1 -ZOMBIE_PERIOD_DECREASE));
          zombieMaximum = cast(Math.min(ZOMBIE_MAXIMUM, zombieMaximum + 1), Int);
          zombieCount--;
        }
      }
    }

    // sort children by y-axis
    ysort(0);
  }
}
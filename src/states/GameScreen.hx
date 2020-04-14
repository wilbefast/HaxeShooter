using h3d.Vector;

class GameScreen extends State {

  private static inline var ZOMBIE_PERIOD = 1.0;
  private static inline var ZOMBIE_DISTANCE = 50.0;

  private var avatar : Avatar;
  private var zombie_timer : Float = ZOMBIE_PERIOD;

  public override function new() {
    super({
      name : "game"
    });
  }

  public override function onEnter(previousState : State) {
    // reset score
    State.score = 0;

    // create avatar
    avatar = new Avatar({
      scene : this
    });
    avatar.x = State.WIDTH / 2;
    avatar.y = State.HEIGHT / 2;
  }

  public override function onLeave(newState : State) {
    State.score = avatar.score;
    Entity.clear();
  }

  public override function onUpdate(dt : Float) {
    // tick the simulation
    Entity.updateAll(dt);
    Collider.generateCollisions(dt);

    // spawn zombies periodically
    zombie_timer -= dt;
    if(zombie_timer <= 0) {
      zombie_timer = ZOMBIE_PERIOD;
      var zombie = new Zombie({
        scene : this
      });
      var angle = Math.random() * Math.PI * 2;
      zombie.x = State.WIDTH * (0.5 + Math.cos(angle));
      zombie.y = State.HEIGHT * (0.5 + Math.sin(angle));
    }
  }

  public override function onEvent(event : hxd.Event) : Void {
    switch(event.kind) {
      case EPush:
        if(event.button == 0) {
          avatar.setFiring(true);
        }
      case ERelease:
        if(event.button == 0) {
          avatar.setFiring(false);
        }
      case EMove:
        avatar.setTarget(event.relX, event.relY);
      case _: 
    }
  }
}
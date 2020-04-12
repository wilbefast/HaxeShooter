import js.html.MouseEvent;
import h2d.Object;

class Main extends hxd.App {
    static function main() : Void {
      new Main();
    }

    private static inline var ZOMBIE_PERIOD = 1.0;
    private static inline var ZOMBIE_DISTANCE = 50.0;

    private var avatar : Avatar;
    private var zombie_timer : Float = ZOMBIE_PERIOD;

    override function init() : Void {
      hxd.Window.getInstance().addEventTarget(onEvent);

      avatar = new Avatar({
        scene : s2d
      });
      avatar.x = s2d.width / 2;
      avatar.y = s2d.height / 2;
    }

    private override function update(dt : Float) : Void {
      // tick the simulation
      Entity.updateAll(dt);
      Collider.generateCollisions(dt);

      // spawn zombies periodically
      zombie_timer -= dt;
      if(zombie_timer <= 0) {
        zombie_timer = ZOMBIE_PERIOD;
        var zombie = new Zombie({
          scene : s2d
        });
        var angle = Math.random() * Math.PI * 2;
        zombie.x = s2d.width * (0.5 + Math.cos(angle));
        zombie.y = s2d.width * (0.5 + Math.sin(angle));
      }
    }

    private function onEvent(event : hxd.Event) : Void {
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
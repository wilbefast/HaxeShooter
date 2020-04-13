import haxe.Ucs2;
import js.html.MouseEvent;
import h2d.Object;

class Main extends hxd.App {
    static function main() : Void {
      new Main();
    }

    override function init() : Void {

      State.init({
        scene : s2d,
        states : [ new Title(), new Game(), new GameOver() ]
      });
      State.setCurrent("title");

      hxd.Window.getInstance().addEventTarget(State.triggerEvent);
    }

    private override function update(dt : Float) : Void {
      State.triggerUpdate(dt);
    }
}
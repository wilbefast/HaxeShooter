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
        states : [ new TitleScreen(), new GameScreen(), new ScoreScreen() ]
      });
      State.setCurrent("title");

      var window = hxd.Window.getInstance();
      window.addEventTarget(State.triggerEvent);
      window.addResizeEvent(function() {
        State.triggerResize(window.width, window.height);
      });
      State.triggerResize(window.width, window.height);
    }

    private override function update(dt : Float) : Void {
      State.triggerUpdate(dt);
    }
}
import haxe.Ucs2;
import js.html.MouseEvent;
import h2d.Object;

class Main extends hxd.App {
    static function main() : Void {
      new Main();
    }

    override function init() : Void {
      // initialise Heaps resource manager
      hxd.Res.initEmbed();

      // set up viewport with letterbox
      s2d.scaleMode = LetterBox(State.WIDTH, State.HEIGHT, false, Center, Center);
      var mask = new h2d.Mask(State.WIDTH, State.HEIGHT, s2d);

      // initialise state machine
      State.init({
        parent : mask,
        states : [ new TitleScreen(), new GameScreen(), new ScoreScreen() ]
      });
      State.setCurrent("title");

      // hook up events
      var window = hxd.Window.getInstance();
      window.addEventTarget(State.triggerEvent);
    }

    private override function update(dt : Float) : Void {
      State.triggerUpdate(dt, s2d.mouseX, s2d.mouseY);
    }
}
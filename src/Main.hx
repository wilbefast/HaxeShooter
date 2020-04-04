import h2d.Object;

class Main extends hxd.App {
    static function main() : Void {
      new Main();
    }

    private var avatar : Avatar;

    override function init() : Void {
      hxd.Window.getInstance().addEventTarget(onEvent);

      avatar = new Avatar({
        s2d : s2d
      });
      avatar.x = s2d.width / 2;
      avatar.y = s2d.height / 2;
    }

    private override function update(dt : Float) : Void {
      Entity.updateAll(dt / 1000);
    }

    private function onEvent(event : hxd.Event) : Void {
    }
}
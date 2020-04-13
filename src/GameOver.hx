using h3d.Vector;

class GameOver extends State {

  public static var score = 0;

  private var timer : Float;

  public override function new() {
    super({
      name : "gameover"
    });
  }

  public override function onEnter(previousState : State) {
    // reset timer
    timer = 0;

    // show score
    var label = new h2d.Text(hxd.res.DefaultFont.get(), this);
    label.text = 'GAME OVER\nscore: $score';
    label.textAlign = Center;
    label.color = new Vector(1, 1, 1);
    label.x = State.scene.width / 2;
    label.y = State.scene.height / 2;
  }

  public override function onUpdate(dt : Float) {
    timer += dt;
  }

  public override function onLeave(newState : State) {
    // hide score
    removeChildren();
  }

  public override function onEvent(event : hxd.Event) {

    // return to title
    switch(event.kind) {
      case EPush:
        if(event.button == 0 && timer > 1.0) {
          State.setCurrent("title");
        }
      case _:
        // do nothing
    }
  }
}
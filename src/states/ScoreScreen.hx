using h3d.Vector;

class ScoreScreen extends State {

  private var timer : Float;

  public override function new() {
    super({
      name : "score"
    });
  }

  public override function onEnter(previousState : State) {
    // reset timer
    timer = 0;

    // show score
    var label = new h2d.Text(hxd.res.DefaultFont.get(), this);
    label.text = 'GAME OVER\nscore: ${State.score}';
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
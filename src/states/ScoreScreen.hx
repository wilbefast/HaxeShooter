import h3d.Vector;

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
    var label = new h2d.Text(State.bigFont, this);
    label.text = 'GAME OVER\n\n\nyou socially distanced\n\n${State.score}   dinosaur';
    if (State.score != 1)
    {
      label.text += 's';
    }
    label.textAlign = Center;
    label.color = new Vector(1, 1, 1);
    label.x = State.WIDTH / 2;
    label.y = State.HEIGHT / 3;
  }

  public override function onUpdate(dt : Float, mouseX : Float, mouseY : Float) {
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
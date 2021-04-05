import h3d.Vector;

class TitleScreen extends State {

  public override function new() {
    super({
      name : "title"
    });
  }

  public override function onEnter(previousState : State) {
    // show title
    var label = new h2d.Text(State.bigFont, this);
    label.text = "DINOSOCIAL\n\nDISTANCING\n\n\n\nby wilbefast\n\nclick to play";
    label.textAlign = Center;
    label.color = new Vector(1, 1, 1);
    label.x = State.WIDTH / 2;
    label.y = State.HEIGHT / 4;
  }

  public override function onLeave(newState : State) {
    // hide title
    removeChildren();
  }

  public override function onEvent(event : hxd.Event) {
    // start the game
    switch(event.kind) {
      case EPush:
        if(event.button == 0) {
          State.setCurrent("game");
        }
      case _:
        // do nothing
    }
  }
}
import 'dart:html';
import 'grid.dart';
import 'package:vector_math/vector_math.dart';

var ctx;
var grid;
var layers;

void main() {
  layers = new List<CanvasElement>();
  CanvasElement canvas = querySelector("#main_canvas");
  layers.add(canvas);
  ctx = canvas.context2D;
  grid = new Grid(new Rectangle<int>(0, 0, 500, 500), new Vector2(25.0, 25.0));
  canvas.onMouseMove.listen(pushGrid);
  canvas.onClick.listen(addExplosion);
  setupCanvases(layers);
  window.animationFrame.then(gameLoop);
}

void addExplosion(MouseEvent e) {
  num x = e.offset.x;
  num y = e.offset.y;
  
  if (e.button == 0) {
    grid.ApplyExplosiveForce(50, new Vector3(x.toDouble(), y.toDouble(), 0.0), 100);
  }
}

void pushGrid(MouseEvent e) {
  num x = e.offset.x;
  num y = e.offset.y;
  
//  grid.ApplyDirectedForce(new Vector3(0.0, 0.0, 50.0), new Vector3(x.toDouble(), y.toDouble(), 0.0), 50);
}
void setupCanvases(List<CanvasElement> layers) {
  for (var canvas in layers) {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  }
}

void update() {
  grid.Update();
}

void draw() {
  grid.Draw(ctx);
}

void gameLoop(num delta) {
  ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
  update();
  draw();
  
  window.animationFrame.then(gameLoop);
}


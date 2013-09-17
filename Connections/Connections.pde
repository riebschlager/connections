import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

VerletPhysics2D physics;
PImage hSrc, sSrc, bSrc;
PGraphics canvas;

void setup() {
  // APP SIZE
  size(1280, 720);

  // CANVAS
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.colorMode(RGB);
  canvas.endDraw();

  // HUE
  hSrc = loadImage("http://img.ffffound.com/static-data/assets/6/d93bd461decc27cc8eb8f1d1a217bfb8919f82b4_m.jpg");
  hSrc.resize(width, height);
  hSrc.loadPixels();

  // SATURATION
  sSrc = loadImage("http://img.ffffound.com/static-data/assets/6/6635d305ea5f3591acf1ef3b4ed39f479f432701_m.jpg");
  sSrc.resize(width, height);
  sSrc.loadPixels();

  // BRIGHTNESS
  bSrc = loadImage("http://img.ffffound.com/static-data/assets/6/233747323cb8107f656d6e6ba0b08de27766f7a8_m.jpg");
  bSrc.resize(width, height);
  bSrc.loadPixels();

  // PHYSICS
  physics = new VerletPhysics2D();
  physics.setDrag(1f);
}

void draw() {
  background(255);
  physics.update();
  canvas.beginDraw();
  for (int i = 0; i < physics.particles.size(); i++) {
    Particle p = (Particle) physics.particles.get(i);
    p.tick();
    p.render(canvas);
    if (p.age > p.lifetime) physics.removeParticle(p);
  }
  canvas.endDraw();
  image(canvas, 0, 0);
}

void mousePressed() {
  physics.clear();
  physics.addParticle(new Particle(mouseX, mouseY, 1));
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    canvas.beginDraw();
    canvas.clear();
    canvas.endDraw();
    physics.clear();
  }
  if (key == 's' || key == 'S') {
    this.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".tif");
    this.save("/Users/criebsch/Dropbox/Public/p5/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png");
  }
}

void saveFrameForVideo() {
  String fileName = nf(frameCount, 5) + ".tif";
  saveFrame("data/video/" + fileName);
}


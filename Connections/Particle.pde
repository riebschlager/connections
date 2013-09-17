class Particle extends VerletParticle2D {

  float radiusNoise, colorNoise, xNoise, yNoise;
  float maxRadius;
  float age, lifetime;
  float radiusStep, colorStep, xStep, yStep;
  float fxMin, fxMax, fyMin, fyMax;
  int strokeColor, behavior;
  float strokeWeight, fillAlpha;

  public Particle(float _x, float _y, int _behavior) {
    super(_x, _y);
    radiusNoise = random(1000);
    colorNoise = random(1000);
    xNoise = random(1000);
    yNoise = random(1000);
    age = 1;
    setBehavior(_behavior);
  }

  public void setBehavior(int _index) {
    behavior = _index;
    switch(_index) {
    case 1:    
      maxRadius = 5;
      lifetime = 2000;
      radiusStep = 0.05;
      colorStep = 0.025;
      xStep = 0.00275;
      yStep = 0.00275;
      fxMin = -1;
      fxMax = 1;
      fyMin = -1;
      fyMax = 1;
      strokeWeight = 0;
      strokeColor = 0x33000000;
      fillAlpha = 100;
      break;
    case 2:
      maxRadius = random(5, 10);
      lifetime = random(10, 500);
      radiusStep = 0.035;
      colorStep = 0.025;
      xStep = 0.00275;
      yStep = 0.00275;
      fxMin = -1;
      fxMax = 1;
      fyMin = -1;
      fyMax = 1;
      strokeWeight = 0;
      strokeColor = 0x33000000;
      fillAlpha = 175;
      break;
    case 3:    
      maxRadius = random(5, 10);
      lifetime = random(10, 100);
      radiusStep = 0.005;
      colorStep = 0.025;
      xStep = 0.00275;
      yStep = 0.00275;
      fxMin = -1;
      fxMax = 1;
      fyMin = -1;
      fyMax = 1;
      strokeWeight = 0;
      strokeColor = 0x33000000;
      fillAlpha = 90;
      break;
    }
  }

  public void tick() {
    radiusNoise += radiusStep;
    colorNoise += colorStep;
    xNoise += xStep;
    yNoise += yStep;
    age++;
    float vx = map(noise(xNoise), 0, 1, fxMin, fxMax);
    float vy = map(noise(yNoise), 0, 1, fyMin, fyMax);
    Vec2D vv = new Vec2D(vx, vy);
    addForce(vv);
    if (random(1) > 0.9 && physics.particles.size() < 20) {
      for (int i = 0; i < 5; i++) {
        Particle p = new Particle(x, y, PApplet.floor(random(1, 4)));
        float r = map(noise(radiusNoise), 0, 1, maxRadius / 2, maxRadius);
        r = r - (r * (age/lifetime));
        p.maxRadius = r;
        p.lifetime = this.lifetime / 1.5;
        physics.addParticle(p);
        physics.addBehavior(new AttractionBehavior(p, 20, random(-1, 1), 0.01f));
      }
    }
  }



  public void render(PGraphics _canvas) {

    // THE PIXEL
    int hPixel = hSrc.get((int) x, (int) y);
    int sPixel = sSrc.get((int) x, (int) y);
    int bPixel = bSrc.get((int) x, (int) y);

    // ITS VALUES
    float h = hue(hPixel);
    float s = saturation(sPixel);
    float b = brightness(bPixel);

    // ITS SIZE
    float r = map(noise(radiusNoise), 0, 1, maxRadius / 2, maxRadius);
    r = r - (r * (age/lifetime));
    r = (r < 1) ? 1 : r;

    // DRAW!
    _canvas.noStroke();
    _canvas.fill(h, s, b, 15);
    _canvas.ellipse(x, y, r, r);

    // CREATE A CONNECTION
    Particle p = particleWithinDistance(100);
    if (p != null) {
      _canvas.stroke(h, s, b, 30);
      _canvas.strokeWeight(0.5);
      _canvas.line(x, y, p.x, p.y);
    }
  }

  public Particle particleWithinDistance(int _distance) {
    for (int i = 0; i < 1000; i++) {
      int index = PApplet.floor(random(physics.particles.size()));
      Particle p = (Particle) physics.particles.get(index);
      float d = PVector.dist(new PVector(p.x, p.y), new PVector(this.x, this.y));
      if (d <= _distance)
        return (Particle) physics.particles.get(index);
    }
    return null;
  }
}


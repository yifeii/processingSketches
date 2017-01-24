import processing.opengl.*;
import geomerative.*;

ArrayList<ParticleSystem> systems;
PVector test;
 
ArrayList <PVector> path = new ArrayList <PVector> ();
ArrayList <Particle> particles = new ArrayList <Particle> ();
 
void setup() {
  size(1200, 1200, OPENGL);
  smooth();
  systems = new ArrayList<ParticleSystem>();
 
  RG.init(this);
  RCommand.setSegmentLength(10);
  RFont font = new RFont("FreeSans.ttf", 200, RFont.CENTER);
  RPoint[] points = font.toGroup("YIFEI").getPoints();
  
 
  int xoff = width/2;
  int yoff = height/3;
 
  for (int i=0; i<points.length; i++) {
    path.add( new PVector(xoff + points[i].x, yoff + points[i].y) );
    print(points[i].x+xoff,points[i].y+yoff);
    //particles.add( new Particle(xoff + points[i].x, yoff + points[i].y, 3, i) );
    systems.add(new ParticleSystem(60, new PVector(xoff + points[i].x, yoff + points[i].y)));
    
  }
}
 
void draw() {
  background(0);
  for (ParticleSystem ps : systems) {
    ps.run();
    ps.addParticle();
  }
  
}



class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin;                   // An origin point for where particles are birthed

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = v.copy();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));    // Add "num" amount of particles to the arraylist
    }
  }


  void run() {
    // Cycle through the ArrayList backwards, because we are deleting while iterating
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {
    Particle p;
    // Add either a Particle or CrazyParticle to the system
    if (int(random(0, 2)) == 0) {
      p = new Particle(origin);
    } 
    else {
      p = new CrazyParticle(origin);
    }
    particles.add(p);
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    return particles.isEmpty();
  }
}



// A subclass of Particle

class CrazyParticle extends Particle {

  // Just adding one new variable to a CrazyParticle
  // It inherits all other fields from "Particle", and we don't have to retype them!
  float theta;

  // The CrazyParticle constructor can call the parent class (super class) constructor
  CrazyParticle(PVector l) {
    // "super" means do everything from the constructor in Particle
    super(l);
    // One more line of code to deal with the new variable, theta
    theta = 0.0;
  }

  // Notice we don't have the method run() here; it is inherited from Particle

  // This update() method overrides the parent class update() method
  void update() {
    super.update();
    // Increment rotation based on horizontal velocity
    float theta_vel = (velocity.x * velocity.mag()) / 10.0f;
    theta += theta_vel;
  }

  // This display() method overrides the parent class display() method
  void display() {
    // Render the ellipse just like in a regular particle
    super.display();
    // Then add a rotating line
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    stroke(255, lifespan);
    //line(0, 0, 25, 0);
    popMatrix();
  }
}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0.1, 0.1);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = l.copy();
    lifespan = 100.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 3, 3);
  }

  // Is the particle still useful?
  boolean isDead() {
    return (lifespan < 0.0);
  }
}
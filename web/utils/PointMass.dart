library geometrywarsclone;

import 'package:vector_math/vector_math.dart';


class PointMass
{
  Vector3 Position = new Vector3.zero();
  Vector3 Velocity = new Vector3.zero();
  num InverseMass;
  
  Vector3 acceleration = new Vector3.zero();
  num damping = 0.98;
  
  PointMass(Vector3 this.Position, num this.InverseMass);
  
  void ApplyForce(Vector3 force) {
    Vector3 v = force * this.InverseMass;
    this.acceleration += v;
  }
  
  void IncreaseDamping(num factor) {
    this.damping *= factor;
  }
 
  void Update() {
    this.Velocity += this.acceleration;
    this.Position += this.Velocity;
    this.acceleration = new Vector3.zero();
    
    if (this.Velocity.length2 < 0.001 * 0.001) {
      this.Velocity = new Vector3.zero();
    }
    
    this.Velocity *= damping;
    this.damping = 0.98;
  }
}
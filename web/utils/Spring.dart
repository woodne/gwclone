library geometrywarsclone;

import 'PointMass.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:html';
class Spring
{
  PointMass End1;
  PointMass End2;
  num TargetLength;
  num Stiffness;
  num Damping;
  
    
  Spring(PointMass this.End1, PointMass this.End2,
         num this.Stiffness, num this.Damping) {
    this.TargetLength = (this.End1.Position - this.End2.Position).length;
  }
  
  void Update()
  {
    var x = this.End1.Position - this.End2.Position;
    
    var length = x.length;
    // These springs can only pull, not push
    if (length <= this.TargetLength)
      return;
    
    x = (x / length) * (length - this.TargetLength);
    var dv = this.End2.Velocity - this.End1.Velocity;
    var force = (x - dv);
    force *= this.Stiffness * this.Damping;
    
    this.End1.ApplyForce(-force);
    this.End2.ApplyForce(force); 
  }
}
library geometrywarsclone;

import 'dart:math';
import 'dart:html';
import 'package:vector_math/vector_math.dart';
import 'utils/PointMass.dart';
import 'utils/Spring.dart';

class Grid {
  List points;
  List<Spring> springList;
  
  Grid(Rectangle size, Vector2 spacing) {
    this.springList = new List();
    
    
    num numColumns = size.width / spacing.x + 1;
    num numRows = size.height / spacing.y + 1;
    this.points = new List(numRows.toInt());
    List fixedPoints = new List(numRows.toInt());
    
    int column = 0, row = 0;
    for (num y = size.top; y <= size.height; y += spacing.y) {
      points[row] = new List(numColumns.toInt());
      fixedPoints[row] = new List(numColumns.toInt());
      for (num x = size.left; x <= size.width; x += spacing.x) {
        points[row][column] = new PointMass(new Vector3(x.toDouble(), y.toDouble(), 0.0), 1.0);
        fixedPoints[row][column] = new PointMass(new Vector3(x.toDouble(), y.toDouble(), 0.0), 0.0);
        column++;
      }
      row++;
      column = 0;
    }
    
    for (num y = 0; y < numRows; y++) {
      for (num x = 0; x < numColumns; x++) {
        if (x == 0 || y == 0 || x == numColumns-1 || y == numRows - 1) // anchor the border of the grid
          this.springList.add(new Spring(fixedPoints[x][y], points[x][y], 0.1, 0.1));
        else if (x % 3 == 0 && y % 3 == 0)
          this.springList.add(new Spring(fixedPoints[x][y], points[x][y], 0.002, 0.002));
        
        const num stiffness = 0.28;
        const num damping = 0.6;
        if (x > 0)
          this.springList.add(new Spring(points[x-1][y], points[x][y], stiffness, damping));
        if (y > 0)
          this.springList.add(new Spring(points[x][y-1], points[x][y], stiffness, damping));
      }
    }
  }
  
  void ApplyExplosiveForce(num force, Vector3 position, num radius) {
    for (var arr in points) {
      for (PointMass mass in arr) {
        num dist2 = (position - mass.Position).length2;
        if (dist2 < radius * radius) {
          Vector3 v = mass.Position - position;
          v *= 100.0;
          v *= force.toDouble();
          v /= (10000.0 + dist2.toDouble());
          
          mass.ApplyForce(v);
          mass.IncreaseDamping(0.6);
        }
      }
    }
  }
  
  void ApplyImplosiveForce(num force, Vector3 position, num radius) {
    for (var arr in points) {
      for (PointMass mass in arr) {
        num dist2 = (position - mass.Position).length2;
        if (dist2 < radius * radius) {
          Vector3 v = mass.Position - position;
          v *= 100.0;
          v *= -force.toDouble();
          v /= (10000.0 + dist2.toDouble());
          
          mass.ApplyForce(v);
          mass.IncreaseDamping(0.6);
        }
      }
    }
  }
  
  void ApplyDirectedForce(Vector3 force, Vector3 position, num radius) {
    for (var arr in points) {
      for (PointMass mass in arr) {
        num dist2 = (position - mass.Position).length2;
        if (dist2 < radius * radius) {
          force.multiply(new Vector3(0.0, 0.0, 0.0).splat(10.0));
          Vector3 v = position - mass.Position;
          v.add(new Vector3(0.0, 0.0, 0.0).splat(10.0));
          force.divide(v);
          mass.ApplyForce(force);
        }
      }
    }
  }
  
  void Update() {
    for (var spring in this.springList) {
      spring.Update();
    }
    for (var arr in points) {
      for (var mass in arr) {
        mass.Update();
      }
    }
  }
  
  void Draw(CanvasRenderingContext2D ctx) {
    ctx.fillStyle = "white";
    ctx.save();
    ctx.translate(3, 3);
    for (var arr in points) {
      for (var mass in arr) {
        ctx.beginPath();
        ctx.arc(mass.Position.x, mass.Position.y, 3, 0, 2 * PI);
        ctx.fill();
      }
    }
    ctx.restore();
  }
}
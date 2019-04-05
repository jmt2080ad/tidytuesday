// void setup()
// {
//   println(sketchPath());
// }


// simple CSV read to spreadsheet
Table data;
int rowCnt = 0;

void setup() {
  size(200, 200);
  frameRate(10);
  data = loadTable("data/bd.csv", "header");
}

void draw() {
  background(255, 255, 255);
  TableRow row = data.getRow(rowCnt);
  int cnt = row.getInt("bike_count");
  ellipse(100, 20 + cnt, 10, 10);
  rowCnt += 1;
}

//data/bd.csv
/*
town,bike_count
here,234
there,567
nowhere,0
*/

// Table table;
// int rowCnt = 0;

// void setup()
// {
//   size(200, 200);
//   smooth();
//   frameRate(1000);
//   data = loadTable("data/bd.csv", "header");
// }


// void draw()
// {
//   background(255, 255, 255);
//   TableRow row = data.getRow(rowCnt);
//   int cnt = row.getInt("bike_count");
//   ellipse(100, 20 + cnt, 10, 10);
//   rowCnt += 1;
// }

// int armAngle = 0;
// int angleChange = 5;
// final int ANGLE_LIMIT = 135;

// void draw()
// {
//   background(255);
//   pushMatrix();
//   translate(50, 50); // place robot so arms are always on screen
//   drawRobot();
//   armAngle += angleChange;  
//   // if the arm has moved past its limit,
//   // reverse direction and set within limits.
//   if (armAngle > ANGLE_LIMIT || armAngle < 0)
//   {
//     angleChange = -angleChange;
//     armAngle += angleChange;
//   }
//   popMatrix();
// }

// void drawRobot()
// {
//   noStroke();
//   fill(38, 38, 200);
//   rect(20, 0, 38, 30); // head
//   rect(14, 32, 50, 50); // body
//   drawLeftArm();
//   drawRightArm();
//   rect(22, 84, 16, 50); // left leg
//   rect(40, 84, 16, 50); // right leg
//   fill(222, 222, 249);
//   ellipse(30, 12, 12, 12); // left eye
//   ellipse(47, 12, 12, 12);  // right eye
// }

// void drawLeftArm()
// {
//   pushMatrix();
//   translate(12, 32);
//   rotate(radians(armAngle));
//   rect(-12, 0, 12, 37); // left arm
//   popMatrix();
// }

// void drawRightArm()
// {
//   pushMatrix();
//   translate(66, 32);
//   rotate(radians(-armAngle));
//   rect(0, 0, 12, 37); // right arm
//   popMatrix();
// }

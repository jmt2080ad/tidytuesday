Table dt;
int[] margins;

void setup() {
  size(600, 600);
  background(#000000);
  margins = [20, 20, 50, 50]; // top, right, bottom, left
  dt = loadTable("./data/prizePapers.csv", "header");
}

void draw(){
  float paper;
  float prize;

  stroke(#000000);
  for (int idx = 0; idx < dt.lastRowIndex(); idx++) {
    prize = gridPoint(idx, "prize_year");
    paper = height - gridPoint(idx, "pub_year");
    ellipse(prize, paper, 5, 5);
  }

  axis("x");
  axis("y");
  
}

class Plot {
  Table dt;
  int[] margins;

  // constrictor 
       plot()
}

float gridPoint(int idx, String var){
  return ( ( dt.getFloat(idx, var) - 1826 ) / ( 2016 - 1826 ) * ( width - 20 ) );
}

void axis(String side) {
  stroke(#FFFFFF);
  if (side.equals("y")) {
    line(20, height - 20, 20, 20);
  }
  
  if (side.equals("x")) {
    line(20, height - 20, width - 20, height - 20);
  }
}

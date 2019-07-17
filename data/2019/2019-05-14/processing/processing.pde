Table dt;
int[] margins = new int[4];
Plot plot;

void setup() {
  size(600, 600);
  background(#000000);
  dt = loadTable("./data/prizePapers.csv", "header");
}

void draw(){
  float paper;
  float prize;

  margins[0] = width / (mouseX+1);
  margins[1] = width / (mouseX+1);
  margins[2] = width / (mouseX+1);
  margins[3] = width / (mouseX+1);
                            
  stroke(#000000);
  plot = new Plot(dt, "prize_year", "pub_year", margins);
  plot.makePlot();
}

class Plot {
  Table dt;
  String x;
  String y;
  int[] margins;
  float xCoord;
  float yCoord;

  Plot (Table _dt, String _x, String _y, int[] _margins) {
    dt = _dt;
    x = _x;
    y = _y;
    margins = _margins;
  };

  void makePlot () {    
    stroke(#000000);
    for (int idx = 0; idx < dt.lastRowIndex(); idx++) {
      xCoord = gridPoint(idx, x);
      yCoord = height - gridPoint(idx, y);
      ellipse(xCoord, yCoord, 5, 5);
    }
    this.axis("x");
    this.axis("y");
  }
  
  float gridPoint(int idx, String var){
    return ( ( dt.getFloat(idx, var) - 1826) / ( 2016 - 1826 ) * ( width - 20 - margins[0] - margins [2]) );
  }

  void axis(String side) {
    stroke(#FFFFFF);
    if (side.equals("y")) {
      line(margins[0],
           margins[1],
           margins[0],
           height - margins[3]);
    }
  
    if (side.equals("x")) {
      line(margins[0],
           height - margins[3],
           width - margins[2],
           height - margins[3]);
    }
  }  
}

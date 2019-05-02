int rowCnt = 0;
File[] cids;
Crossing[] data;
int minRows;

void setup() {
  size(800, 300);
  frameRate(8);
  cids = listFiles("data");
  data = new Crossing[2];
  data = new Crossing[cids.length];
  int space = 30;
  minRows = 0;
  for (int i = 0; i < cids.length; i++){
    data[i] = new Crossing(cids[i].getPath(),
                           width - space, (i * space) + space,
                           space, 28);
    if (i == 0 || minRows < data[i].rowCount) {
      minRows = data[i].rowCount;
    }
  }
}

void draw() {
  background(255, 255, 255);
  
  for (int i = 0; i < data.length; i++) {
    data[i].setTailVals(rowCnt, "d1");
    data[i].drawTailLine(#6F4FFF);
    data[i].setTailVals(rowCnt, "d2");
    data[i].drawTailLine(#9F2244);
  }

  data[0].setAxisVals(rowCnt, "day");
  data[0].drawAxisLine(#000000, -8, 12);
  data[0].setAxisVals(rowCnt, "hour");
  data[0].drawAxisLine(#000000, -8, 24);

  if (rowCnt < minRows) {
    rowCnt += 1;
  } else {
    rowCnt = 0;
  }
}

class Data {
  Table dt;
  int rowCount;

  void readTable(String path){
      dt = loadTable(path, "header");
      rowCount = dt.getRowCount();
  }

  int getIntFromData(int idx, String var) {
    return dt.getInt(idx, var);    
  }

  String getStringFromData(int idx, String var) {
    String val = dt.getString(idx, var);
    if(val.length() == 1){
      val = " " + val;
    };
    return val;
  }
}

class Crossing extends Data {
  String path;
  int xOrig;
  int yOrig;
  int space;  
  int tailLen;
  String var;
  int[] tailVal;
  String[] axisVal;
  int aOffset;
  
  Crossing (String path_, int xOrig_, int yOrig_, int space_, int tailLen_){
    path    = path_;
    xOrig   = xOrig_;
    yOrig   = yOrig_;
    space   = space_;
    tailLen = tailLen_;
    this.readTable(path);
  }

  void setTailVals(int idx, String var) {
    tailVal = new int[tailLen];
    if(idx < tailLen){
      int zIdx = idx;
      for(int i = 0; i <= zIdx; i++){
        tailVal[i] = getIntFromData(idx, var);
        idx--;
      }
      for(int i = zIdx + 1; i < tailLen; i++){
        tailVal[i] = 0;
      }
    }
    if(idx >= (tailLen)){
      for(int i = 0; i < tailLen; i++){
        tailVal[i] = getIntFromData(idx, var);
        idx--;
      }
    }
  }

  void setAxisVals(int idx, String var) {
    axisVal = new String[tailLen];
    int holdIdx = idx;
    if(idx < tailLen){
      for(int i = 0; i <= holdIdx; i++){
        String val = getStringFromData(idx, var);
        if(idx != 0 && val.equals(getStringFromData(idx - 1, var))){
          axisVal[i] = " ";
        } else {
          axisVal[i] = val;
        }
        idx--;
      }
      for(int i = holdIdx + 1; i < tailLen; i++){
        axisVal[i] = " ";
      }
    }
    if(idx >= tailLen){
      for(int i = 0; i < tailLen; i++){
        String val = getStringFromData(idx, var);
        if(idx != 0 && val.equals(getStringFromData(idx - 1, var))){
          axisVal[i] = " ";
        } else {
          axisVal[i] = val;
        }
        idx--;
      }
    }
  }

  void drawTailLine(int col) {
    for(int i = 0; i < (tailLen - 1); i++){
      stroke(col, map(i, 0, (tailLen - 1), 255, 10));
      line(xOrig - (i * space),
           height - tailVal[i] - yOrig,
           xOrig - ((i + 1) * space),
           height - tailVal[i + 1] - yOrig);
    }
    fill(0);
    stroke(0);
    ellipse(xOrig, height - tailVal[0] - yOrig, 2, 2);
  }
    
  void drawAxisLine(int col, int xShift, int yShift) {
    for(int i = 0; i < (tailLen - 1); i++){
      fill(col, map(i, 0, (tailLen - 1), 255, 10));
      text(axisVal[i],
           xOrig - (i * space) + xShift,
           height - yOrig + yShift);
    }
  }
}

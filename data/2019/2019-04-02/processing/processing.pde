int rowCnt = 0;
File[] cids;
Crossing[] data;

void setup() {
  size(800, 300);
  frameRate(12);
  cids = listFiles("data");
  data = new Crossing[cids.length];
  for(int i = 0; i < cids.length; i++){
    data[i] = new Crossing(cids[i].getPath());
  }
}

void draw() {
  int space = 30;
  background(255, 255, 255);
  for(int i = 0; i < data.length; i++){
    data[i].setTailVals(rowCnt, 36, "d1");
    data[i].getTailLine(width - space, (i * space) + space, space, #6F4FFF);
  }
  for(int i = 0; i < data.length; i++){
    data[i].setTailVals(rowCnt, 36, "d2");
    data[i].getTailLine(width - space, (i * space) + space, space, #9F2244);
  }
  if(rowCnt < 8784){
    rowCnt += 1;
  } else {
    rowCnt = 0;
  }
}

class Crossing {
  String path;
  Table dt;
  int[] tailVal;

  Crossing (String path_) {
    path = path_;
    dt = loadTable(path, "header");    
  }

  int getValFromData(int idx, String var) {
    TableRow row = dt.getRow(idx);
    return row.getInt(var);    
  }
  
  void setTailVals(int idx, int tailLen, String var) {
    tailVal = new int[tailLen];
    if(idx < (tailVal.length - 1)){
      for(int i = idx; i > 0; i--){
        tailVal[idx - i] = getValFromData(idx, var);
        idx--;
      }
      for(int i = tailLen - idx + 1; i < tailLen; i++){
        tailVal[i] = 0;
      }
    }
    if(idx > (tailLen - 1)){
      for(int i = 0; i < tailLen; i++){
        tailVal[i] = getValFromData(idx, var);
        idx--;
      }
    }
  }
  
  void getTailLine(int tailx, int taily, int scalex, int col) {
    for(int i = 0; i < (tailVal.length - 1); i++){
      stroke(col, map(i, 0, (tailVal.length - 1), 255, 10));
      line(tailx - (i * scalex),
           height - tailVal[i] - taily,
           tailx - ((i + 1) * scalex),
           height - tailVal[i + 1] - taily);
    }
    fill(0);
    stroke(0);
    ellipse(tailx, height - tailVal[0] - taily, 2, 2);
  }
}

// class Axis extends Tail{
//   int xOrig;
//   int yOrig;
//   int space;
//   int tailLen;
//   Tail tail;
//   String var;

//   Axis(int xOrig_, int yOrig_, int space_, int tailLen_, String var_){
//     xOrig   = xOrig_;
//     yOrig   = yOrig_;
//     space   = space_;
//     tailLen = tailLen_;
//     var = var_;
//   };
  
//   void getAxisVals(int idx, int tailLen, String var){
//     tail = new Tail(xOrig, yOrig, space, tailLen, dt);
//     if(idx < (tailLen - 1)){
//       for(int i = idx; i > 0; i--){
//         tail[idx - i] = getVal(idx, var);
//         idx--;
//       }
//       for(int i = tailLen - idx + 1; i < tailLen; i++){
//         tail[i] = 0;
//       }
//     }    
//   };

//   void getAxis(int tailx, int taily, int scalex, int col) {
//     for(int i = 0; i < (tail.length - 1); i++){
//       stroke(col, map(i, 0, (tail.length - 1), 255, 10));
//       text(tail[i], tailx - (i * scalex), height - tail[i] - taily);
//     }
//   }
// }

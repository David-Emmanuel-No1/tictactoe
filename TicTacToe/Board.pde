enum WinDir {
  ROW, COL, DGL, NONE, DRAW
};

class Board {
  float[] lineX, lineY;
  Button[] buttons;
  int lastMove;
  String player, lastPlayer;
  int scoreX, scoreO, scoreD;
  int n, winN;
  float w, h;
  Line winLine;
  Win win;

  Board(int _n, int _winN) {
    this.n = _n;
    this.winN = _winN;

    lineY = new float[n+1];
    float realHeight = height-padding[0]-padding[2];
    h = realHeight/n;
    for (int i=0; i<n+1; i++) {
      lineY[i] = padding[0] + i*h;
    }

    lineX = new float[n+1];
    float realWidth = height-padding[3]-padding[1];
    w = realWidth/n;
    for (int i=0; i<n+1; i++) {
      lineX[i] = padding[3] + i*w;
    }

    buttons = new Button[n*n];
    for (int i=0; i<n*n; i++) {
      float x = lineX[i%n];
      float y = lineY[i/n];
      buttons[i] = new Button(x, y, w, h);
      buttons[i].textSize = realHeight/n;
      buttons[i].textColor = color(255);
      buttons[i].rectMode = CORNER;
      buttons[i].border = false;
      buttons[i].fill = false;
    }
    lastPlayer = "O";
    scoreX = 0;
    scoreO = 0;
    scoreD = -1;
    win = new Win();
    reset();
  }

  void reset() {
    player = lastPlayer=="O"?"X":"O";
    lastPlayer = lastPlayer=="O"?"X":"O";
    lastMove = -1;
    if (win.winStr.equals("X")) {
      scoreX++;
    } else if (win.winStr.equals("O")) {
      scoreO++;
    } else {
      scoreD++;
    }
    win = new Win();
    winLine = new Line();
    for (Button b : buttons) {
      b.text = " ";
    }
  }

  void update() {
    _update(getPressed());
  }

  void update(int index) {
    _update(index);
  }

  void _update(int move) {
    if (move > -1) {
      lastMove = move;
    }

    if (win.winDir == WinDir.NONE) {
      win = checkWin();
    }

    if (win.winDir == WinDir.NONE) {
      if (lastMove>-1 && buttons[lastMove].text.equals(" ")) {
        buttons[lastMove].text = new String(player);

        if (player.equals("X")) {
          player = "O";
        } else if (player.equals("O")) {
          player = "X";
        }
      }
    } else {
      setWinLine();
      if (n_humans==0) {
        reset();
      } else if (ui.touched) {
        reset();
      }
    }
  }

  void setWinLine() {
    if (win.winDir == WinDir.ROW) {
      float y = lineY[win.winInt]+h/2;
      winLine.set(lineX[0], y, lineX[n], y);
    } else if (win.winDir == WinDir.COL) {
      float x = lineX[win.winInt]+w/2;
      winLine.set(x, lineY[0], x, lineY[n]);
    } else if (win.winDir == WinDir.DGL) {
      if (win.winInt == 0) {
        winLine.set(lineX[0], lineY[0], 
          lineX[n], lineY[n]);
      } else {
        winLine.set(lineX[0], lineY[n], 
          lineX[n], lineY[0]);
      }
    }
  }

  Win checkWin() {
    //    if (lastMove > -1) {
    String rowWin = " ";
    int winRow = -1;
    for (int y=0; y<n; y++) {
      for (int x=0; x<n; x++) {
        int i = x+y*n;
        String text = buttons[i].text;
        if (text.equals(" ")) {
          rowWin = " ";
          break;
        }
        if (rowWin.equals(" ")) {
          rowWin = new String(text);
        } else if (!rowWin.equals(text)) {
          rowWin = " ";
          break;
        } else if (x == n-1) {
          winRow = y;
          return new Win(WinDir.ROW, rowWin, winRow);
        }
      }
    }

    String colWin = " ";
    int winCol = -1;
    for (int x=0; x<n; x++) {
      for (int y=0; y<n; y++) {
        int i = x+y*n;
        String text = buttons[i].text;
        if (text.equals(" ")) {
          colWin = " ";
          break;
        }
        if (colWin.equals(" ")) {
          colWin = new String(text);
        } else if (!colWin.equals(text)) {
          colWin = " ";
          break;
        } else if (y == n-1) {
          winCol = x;
          return new Win(WinDir.COL, colWin, winCol);
        }
      }
    }

    String dglWin = " ";
    int winDgl = -1;
    for (int x=0; x<n; x++) {
      int y = x;
      int i = x+y*n;
      String text = buttons[i].text;
      if (text.equals(" ")) {
        dglWin = " ";
        break;
      }
      if (dglWin.equals(" ")) {
        dglWin = new String(text);
      } else if (!dglWin.equals(text)) {
        dglWin = " ";
        break;
      } else if (x == n-1) {
        winDgl = 0;
        return new Win(WinDir.DGL, dglWin, winDgl);
      }
    }

    if (dglWin.equals(" ")) {
      for (int x=0; x<n; x++) {
        int y = n-x-1;
        int i = x+y*n;
        String text = buttons[i].text;
        if (text.equals(" ")) {
          dglWin = " ";
          break;
        }
        if (dglWin.equals(" ")) {
          dglWin = new String(text);
        } else if (!dglWin.equals(text)) {
          dglWin = " ";
          break;
        } else if (x == n-1) {
          winDgl = 1;
          return new Win(WinDir.DGL, dglWin, winDgl);
        }
      }
    }

    boolean draw = true;
    for (int i=0; i<n*n; i++) {
      String text = buttons[i].text;
      draw &= !text.equals(" ");
    }
    if (draw) {
      return new Win(WinDir.DRAW, " ", 0);
    }

    return new Win();
  }

  int getPressed() {
    int clicked = -1;
    for (int i=0; i<buttons.length; i++) {
      if (buttons[i].isTouched()) {
        clicked = i;
        break;
      }
    }
    return clicked;
  }

  void display() {
    strokeWeight(5);
    stroke(0);
    for (int i=1; i<n; i++) {
      line(lineX[i], lineY[0], lineX[i], lineY[n]);
    }
    for (int i=1; i<n; i++) {
      line(lineX[0], lineY[i], lineX[n], lineY[i]);
    }
    for (int i=0; i<buttons.length; i++) {
      buttons[i].display();
    }
    stroke(0);
    strokeWeight(7.5);
    winLine.display();
    textSize(50);
  }

  String getState() {
    String state = "";
    for (Button b : buttons) {
      state += b.text;
    }
    return state;
  }
}

class Win {
  boolean row;
  String winStr;
  int winInt;
  WinDir winDir;
  Win() {
    this.winDir = WinDir.NONE;
    this.winStr = " ";
    this.winInt = -1;
  }
  Win(WinDir d, String s, int i) {
    this.winDir = d;
    this.winStr = new String(s);
    this.winInt = i;
  }
}

class Line {
  float x1, y1, x2, y2;
  Line() {
    this.x1 = -1;
    this.x2 = -1;
    this.y1 = -1;
    this.y2 = -1;
  }
  void set(float _x1, float _y1, float _x2, float _y2) {
    this.x1 = _x1;
    this.x2 = _x2;
    this.y1 = _y1;
    this.y2 = _y2;
  }
  void display() {
    line(x1, y1, x2, y2);
  }
}

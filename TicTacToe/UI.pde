UI ui = new UI();
class UI {
  int touchWait = -1;
  boolean touched = false;

  void update() {
    touchWait -= 1;
    touched = mousePressed && touchWait<0;
    if (touched) {
      touchWait = 5;
    }
  }
}

class Button {
  float x, y, w, h;
  float borderRadius, borderSize, textSize;
  boolean border, fill;
  color fillColor, borderColor, textColor;
  String text;
  int rectMode;

  Button(float _x, float _y, float _w, float _h) {
    this.x = _x;
    this.y = _y;
    this.w = _w;
    this.h = _h;

    this.border = true;
    this.fill = true;

    this.borderRadius = 0;
    this.borderSize   = 1;
    this.textSize     = 32;

    this.fillColor   = color(255, 0, 0);
    this.borderColor = color(0);
    this.textColor   = color(255);

    this.text = " ";
    this.rectMode = CENTER;
  }

  void display() {
    textAlign(CENTER, CENTER);
    rectMode(rectMode);

    if (fill) {
      fill(fillColor);
    } else {
      noFill();
    }

    if (border) {
      stroke(borderColor);
    } else {
      noStroke();
    }

    strokeWeight(borderSize);
    rect(x, y, w, h, borderRadius);

    fill(textColor);
    textSize(textSize);
    if (rectMode == CENTER) {
      text(text, x, y);
    } else if (rectMode == CORNER) {
      text(text, x+w/2, y+h/2);
    }
  }

  boolean isTouched() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector min = new PVector();
    if (rectMode == CENTER) {
      min.set(x-w/2, y-h/2);
    } else if (rectMode == CORNER) {
      min.set(x, y);
    }
    boolean checkX = (mouse.x >= min.x) && (mouse.x <= min.x+w);
    boolean checkY = (mouse.y >= min.y) && (mouse.y <= min.y+h);
    return checkX && checkY && ui.touched;
  }
}

class Selector<T> extends Button {
  T[] values;
  int index;
  
  Selector (float _x, float _y, float _w, float _h) {
    super(_x,_y,_w,_h);
    index = 0;
  }
  
  void update() {
    if (isTouched()) {
      index += 1;
    }
    index = index % values.length;
    text = String.valueOf(values[index]);
  }
  
  void set(T[] _values) {
    this.values = _values;
    index = 0;
  }
  
  T getValue() {
    return values[index];
  }
}

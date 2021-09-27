class Fool {
  int n;
  Fool(int _n) {
    this.n = _n;
  }
  int react() {
    return floor(random(n));
  }
}
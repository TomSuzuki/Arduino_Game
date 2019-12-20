// controllerからとってきたデータを成型してゲームに渡す

int controller_AngleX(int n) {
  return class_Arduino.getAngleX(n);
}

int controller_AngleY(int n) {
  return class_Arduino.getAngleY(n);
}
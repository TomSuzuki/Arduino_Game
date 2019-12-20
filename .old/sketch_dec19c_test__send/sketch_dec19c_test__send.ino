void setup() {
  Serial.begin(9600);
}

void loop() {
  if ( Serial.available() >= 3 ) {
    if ( Serial.read() == 'H' ) {
      byte high = Serial.read();
      byte low  = Serial.read();
      int recv_data = high * 256 + low;  // 受信データ

      // 受信確認のために、数値を文字列で送り返す
      Serial.println(recv_data);
    }
  }
}

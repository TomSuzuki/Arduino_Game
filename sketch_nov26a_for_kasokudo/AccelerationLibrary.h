/* 
 *  2019-11-26 TomSuzuki
 *  version 1.00
 *  
 *  使い方のメモ
 * 
 * // クラスを作る
 * AccelerationClass ac = AccelerationClass();
 * 
 * // setup内で呼ぶ
 * ac.setup();
 * 
 * // 加速度センサの情報を更新する
 * ac.update();
 * 
 * // データを取る
 * Serial.print(ac.getAngleX());
 * Serial.print(ac.getAngleY());
 * 
 */

#include <Wire.h>
#include "Arduino.h"

// 加速度センサ用
// レジスタアドレス
#define MPU6050_ACCEL_XOUT_H 0x3B  // R  
#define MPU6050_WHO_AM_I     0x75  // R
#define MPU6050_PWR_MGMT_1   0x6B  // R/W
#define MPU6050_I2C_ADDRESS  0x68

class AccelerationClass {

    // 使用する構造体
    typedef union accel_t_gyro_union {
      struct {
        uint8_t x_accel_h;
        uint8_t x_accel_l;
        uint8_t y_accel_h;
        uint8_t y_accel_l;
        uint8_t z_accel_h;
        uint8_t z_accel_l;
        uint8_t t_h;
        uint8_t t_l;
        uint8_t x_gyro_h;
        uint8_t x_gyro_l;
        uint8_t y_gyro_h;
        uint8_t y_gyro_l;
        uint8_t z_gyro_h;
        uint8_t z_gyro_l;
      }
      reg;
      struct {
        int16_t x_accel;
        int16_t y_accel;
        int16_t z_accel;
        int16_t temperature;
        int16_t x_gyro;
        int16_t y_gyro;
        int16_t z_gyro;
      }
      value;
    };

    // 角度保管用
    struct angles {
      float x;
      float y;
      float z;
    };

  private:
    angles cor_angle = {0, 0, 0};  // 補正用角度
    angles now_angle = {0, 0, 0}; // 現在の角度を入れる
    int MPU6050_read(int start, uint8_t *buffer, int size);
    int MPU6050_write(int start, const uint8_t *pData, int size);
    int MPU6050_write_reg(int reg, uint8_t data);

  public:
    AccelerationClass();  // コンストラクタ
    void setup();
    int getAngleX(); // xのゲッター
    int getAngleY(); // yのゲッター
    void update(); // センサーの値を取得する

};

// コンストラクタ
AccelerationClass::AccelerationClass() {
}

// setup内で呼ぶもの
void AccelerationClass::setup() {
  uint8_t c;
  MPU6050_read(MPU6050_WHO_AM_I, &c, 1);
  MPU6050_read(MPU6050_PWR_MGMT_1, &c, 1);
  MPU6050_write_reg(MPU6050_PWR_MGMT_1, 0);
  update();
  cor_angle = { now_angle.x, now_angle.y, now_angle.z};
}

// getX（float取ると多分いろいろ面倒）
int AccelerationClass::getAngleX() {
  return int(now_angle.x - cor_angle.x);
}

// getY
int AccelerationClass::getAngleY() {
  return int(now_angle.y - cor_angle.y);
}

// update sensor
void AccelerationClass::update() {
  int error;
  float dT;
  accel_t_gyro_union accel_t_gyro;

  // 加速度、角速度の読み出し
  // accel_t_gyroは読み出した値を保存する構造体、その後ろの引数は取り出すバイト数
  MPU6050_read(MPU6050_ACCEL_XOUT_H, (uint8_t *)&accel_t_gyro, sizeof(accel_t_gyro));

  // 取得できるデータはビッグエンディアンなので上位バイトと下位バイトの入れ替え（AVRはリトルエンディアン）
  uint8_t swap;
#define SWAP(x,y) swap = x; x = y; y = swap
  SWAP (accel_t_gyro.reg.x_accel_h, accel_t_gyro.reg.x_accel_l);
  SWAP (accel_t_gyro.reg.y_accel_h, accel_t_gyro.reg.y_accel_l);
  SWAP (accel_t_gyro.reg.z_accel_h, accel_t_gyro.reg.z_accel_l);
  SWAP (accel_t_gyro.reg.t_h, accel_t_gyro.reg.t_l);
  SWAP (accel_t_gyro.reg.x_gyro_h, accel_t_gyro.reg.x_gyro_l);
  SWAP (accel_t_gyro.reg.y_gyro_h, accel_t_gyro.reg.y_gyro_l);
  SWAP (accel_t_gyro.reg.z_gyro_h, accel_t_gyro.reg.z_gyro_l);

  // 取得した加速度値を分解能で割って加速度(G)に変換する
  float acc_x = accel_t_gyro.value.x_accel / 16384.0; //FS_SEL_0 16,384 LSB / g
  float acc_y = accel_t_gyro.value.y_accel / 16384.0;
  float acc_z = accel_t_gyro.value.z_accel / 16384.0;

  // 加速度からセンサ対地角を求める
  float acc_angle_x = atan2(acc_x, acc_z) * 360 / 2.0 / PI;
  float acc_angle_y = atan2(acc_y, acc_z) * 360 / 2.0 / PI;
  float acc_angle_z = atan2(acc_x, acc_y) * 360 / 2.0 / PI;

  // 現在の（センサが取得した）角度をセットする
  now_angle = {acc_angle_x, acc_angle_y, acc_angle_z};
}

// MPU6050_read
int AccelerationClass::MPU6050_read(int start, uint8_t *buffer, int size) {
  int i, n, error;
  Wire.beginTransmission(MPU6050_I2C_ADDRESS);
  n = Wire.write(start);
  if (n != 1)  return (-10);
  n = Wire.endTransmission(false);// hold the I2C-bus
  if (n != 0) return (n);
  // Third parameter is true: relase I2C-bus after data is read.
  Wire.requestFrom(MPU6050_I2C_ADDRESS, size, true);
  i = 0;
  while (Wire.available() && i < size) buffer[i++] = Wire.read();
  if ( i != size) return (-11);
  return (0); // return : no error
}

// MPU6050_write
int AccelerationClass::MPU6050_write(int start, const uint8_t *pData, int size) {
  int n, error;
  Wire.beginTransmission(MPU6050_I2C_ADDRESS);
  n = Wire.write(start);// write the start address
  if (n != 1)  return (-20);
  n = Wire.write(pData, size);// write data bytes
  if (n != size)  return (-21);
  error = Wire.endTransmission(true); // release the I2C-bus
  if (error != 0)  return (error);
  return (0);// return : no error
}

// MPU6050_write_reg
int AccelerationClass::MPU6050_write_reg(int reg, uint8_t data) {
  return MPU6050_write(reg, &data, 1);
};

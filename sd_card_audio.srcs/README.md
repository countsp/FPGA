#### 使用AV7k325开发板读取sd卡中wav文件并以i2s格式输出

#### 设备：

1. AV7K325 开发板
   
2. MAX 98357A功放
   
3. 扬声器

![IMG_4137(20240510-171741)](https://github.com/countsp/FPGA/assets/102967883/bfa95b44-33c5-4eb9-8ca7-788cdc740672)

#### 操作：

pin11 AK23为生成的bdlk与pin6 AF21连接 再与功放板bclk连接

pin12 AK24为生成的Irc与 pin9 AG24连接再与功放板Irc连接

pin5 AF20为生成的sdata 与 功放板din连接

功放板供电

按下key2 开始播放sd卡中wav

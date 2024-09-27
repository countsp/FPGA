#### 使用AV7k325开发板读取sd卡中**6个**wav文件并以i2s格式输出，实现六路音频播放

#### 设备：

1. AV7K325 开发板
   
2. MAX 98357A功放 * 6
   
3. 扬声器 * 6

![IMG_4137(20240510-171741)](https://github.com/countsp/FPGA/assets/102967883/bfa95b44-33c5-4eb9-8ca7-788cdc740672)

#### 操作：

pin35 AC22 为生成的 **bclk** （紫色）与6个功放板BCLK连接

pin36 AD22 为生成的 **LRC** （蓝色）与功放板LRC连接

生成的 **sdata** 与 功放板din连接

功放板供电

按下key2 开始播放sd卡中wav

![image](https://github.com/user-attachments/assets/71987747-9c8b-41d1-a1f0-945073272452)


# 文件功能

1. top.v

top.v是顶层模块，主要负责连接所有子模块，并完成系统时钟的生成、状态指示等工作。

    输入信号包括复位信号、按键输入、音频位时钟、ADC采样率左右时钟、系统时钟差分输入等。
    输出信号包括LED指示灯、风扇PWM控制信号、DAC音频数据输出、SD卡SPI模式信号等。
    创建系统时钟和50M时钟，通过时钟分频生成I2S接口的bclk和lrc时钟。
    实例化并连接sd_card_audio模块，实现音频数据的读取和播放。

2. sd_card_audio.v

sd_card_audio.v模块负责SD卡的音频数据读取和处理。

    通过按键触发音频播放，按键经过防抖处理。
    通过wav_read模块查找并读取WAV文件数据，数据存入FIFO缓冲区。
    通过audio_tx模块将FIFO中的数据按照I2S协议发送至DAC。

3. ax_debounce.v

ax_debounce.v模块是一个按键防抖模块。

    输入为按键信号，输出为按键的边沿检测信号和消抖后的按键状态。
    通过一个32位计数器实现消抖。

4. audio_tx.v

audio_tx.v模块负责将音频数据通过I2S接口发送至DAC。

    输入为音频数据、位时钟和左右时钟，输出为I2S数据流。
    内部有两个移位寄存器，分别处理左右声道的数据，并在时钟边沿将数据移出。

5. lut_wm8731.v

lut_wm8731.v模块定义了WM8731音频编解码器的寄存器配置表。

    通过查找表的方式提供不同寄存器的初始化值。

6. wav_read.v

wav_read.v模块负责查找并读取SD卡上的WAV文件。

    包括状态机的设计，用于管理SD卡的初始化、文件查找、数据读取等过程。
    数据读取完成后，通过FIFO缓冲区存储音频数据，供sd_card_audio模块使用。

7. sd_card_top.v

sd_card_top.v模块实现SD卡的SPI通信控制。

    包括SD卡的初始化、数据读写、时钟分频等功能。
    与sd_card_cmd模块和spi_master模块协作完成SD卡的命令发送和数据传输。

8. sd_card_cmd.v

sd_card_cmd.v模块负责发送SD卡的命令，并处理返回的数据。

    实现了SPI协议下的SD卡命令发送和接收逻辑。

9. sd_card_sec_read_write.v

sd_card_sec_read_write.v模块实现SD卡扇区读写操作。

    控制SPI时钟分频，管理读写请求和数据传输。

10. spi_master.v

spi_master.v模块实现SPI主控逻辑。

    包括数据移位寄存器、时钟生成、片选控制等。

11. i2c_master_top.v

i2c_master_top.v模块实现I2C总线主控逻辑。

    用于配置WM8731音频编解码器的寄存器。
    包括I2C读写请求的处理、总线仲裁、时序控制等。

12. i2c_master_defines.v

i2c_master_defines.v定义了I2C控制器使用的宏。

    包括I2C命令的定义，如启动、停止、读、写等命令。

13. i2c_master_byte_ctrl.v

i2c_master_byte_ctrl.v模块负责I2C字节级控制。

    实现了I2C总线上的字节传输，包括起始条件、停止条件、数据读写等。

14. i2c_master_bit_ctrl.v

i2c_master_bit_ctrl.v模块负责I2C位级控制。

    处理I2C总线上的位传输，包含SCL和SDA线的控制逻辑。

15. i2c_config.v

i2c_config.v模块用于初始化和配置WM8731音频编解码器。

    通过I2C接口写入配置数据到WM8731的寄存器中。

16. timescale.v

timescale.v定义了仿真时间单位和精度。
整体项目功能

该项目通过FPGA实现了从SD卡读取WAV音频文件并播放的功能。具体流程如下：

    初始化SD卡并查找WAV音频文件。
    读取WAV文件的数据并存入FIFO缓冲区。
    通过I2S接口将音频数据发送至DAC进行播放。
    支持按键触发播放，状态通过LED指示。

 

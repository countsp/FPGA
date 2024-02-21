### IBUFDS
##### IBUFDS 即专用差分输入时钟缓冲器（Dedicated Differential Signaling Input Buffer with Selectable I/O Interface）

IBUFDS：在实验工程中如果需要将差分时钟转换成单端时钟作为全局时钟，需要添加例化此原语。
![IBUFDS](https://img-blog.csdnimg.cn/9641a616369d48e09a2b8e7da19bce1f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBATGluZXN0LTU=,size_20,color_FFFFFF,t_70,g_se,x_16)

```
IBUFDS #(
	.DIFF_TERM("TRUE"),       // use Differential Termination 在芯片内部激活差分终端电阻，以改善信号的接收质量。
	.IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 优先考虑低功耗而非最高性能。
	.IOSTANDARD("DEFAULT")     // Specify the input I/O standard 使用板上默认的 I/O 标准。
) u_ibuf_sys_clk (
	.O(sys_clk),  // Buffer output
	.I(sys_clk_p),  // Diff_p buffer input (connect directly to top-level port)
	.IB(sys_clk_n) // Diff_n buffer input (connect directly to top-level port)
);       
```
### ODDR
ODDR全称output double date rate，ODDR将FPGA fabric侧的同步数据传输到 IOB侧，在FPGA侧时钟的上升沿和下降沿都传输数据，通常使用在并转串数据设计中，如网口的GMII信号转换为RGMII信号。

![ODDR](https://img-blog.csdnimg.cn/29504df3395f4081991c7b64632b34dc.png)

C：同步时钟输入端口

CE：时钟使能端口，高电平有效

D1、D2：并行数据输入端口

S/R：置位复位管脚

Q：串并转化后的数据输出端口，在时钟C端的上升沿输出D1数据，下降沿输出D2数据。如果两路输入信号一路固定为 1，另外一路固定为 0，那么输出的信号实际上是时钟信号，这也是时钟输出使用较多的方式之一。

```
ODDR #(
	.DDR_CLK_EDGE("SAME_EDGE")
) ODDR_inst (
	.Q        (clk_out  ),                   // 1-bit DDR output data
	.C        (pll_clk_o),                   // 1-bit clock input
	.CE       (1'b1     ),                   // 1-bit clock enable input
	.D1       (1'b1     ),                   // 1-bit data input (associated with C)
	.D2       (1'b0     ),                   // 1-bit data input (associated with C)
	.R        (1'b0     ),                   // 1-bit reset input
	.S        (1'b0     )                    // 1-bit set input
);

```

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

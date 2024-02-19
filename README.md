### IBUFDS
##### IBUFDS 即专用差分输入时钟缓冲器（Dedicated Differential Signaling Input Buffer with Selectable I/O Interface）

IBUFDS：在实验工程中如果需要将差分时钟转换成单端时钟作为全局时钟，需要添加例化此原语。
![IBUFDS](https://img-blog.csdnimg.cn/9641a616369d48e09a2b8e7da19bce1f.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBATGluZXN0LTU=,size_20,color_FFFFFF,t_70,g_se,x_16)

```
IBUFDS #(
      .DIFF_TERM("FALSE"),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(O),  // Buffer output
      .I(I),  // Diff_p buffer input (connect directly to top-level port)
      .IB(IB) // Diff_n buffer input (connect directly to top-level port)
   );
```

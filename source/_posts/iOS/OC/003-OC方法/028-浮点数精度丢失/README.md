---
title: iOS中浮点数精度丢失
date: {{ date }}
tags:
- iOS
- float
---

## 参考

[深入浅出iOS浮点数精度问题 (上)](https://blog.csdn.net/yangxiaohei1234/article/details/77870749)

[iOS 关于网络数据解析小数位精度丢失问题的修正](https://blog.csdn.net/txz_gray/article/details/53303918)

[iOS - Json解析精度丢失处理(NSString, Double, Float)](https://www.jianshu.com/p/83d4bc28cc7c)

[124.浮点型数据精度不准确的探究](https://blog.csdn.net/wangyanchang21/article/details/71036031)


## 一、引入

```
double firstD = 11111.7;
double secondD = 22222.6;

NSString * firstDStr = [NSString stringWithFormat:@"%0.2f",firstD];
NSString * secondDStr = [NSString stringWithFormat:@"%0.2f",secondD];

LXLog(@"EE = %@ == %@",firstDStr,secondDStr);

double f = [firstDStr doubleValue];
double s = [secondDStr doubleValue];

LXLog(@"FF = %f == %f",f,s);

LXLog(@"GG = %.12f == %.12f",f,s);
```
```
************** Log *****************
EE = 11111.70 == 22222.60
FF = 11111.700000 == 22222.600000
GG = 11111.700000000001 == 22222.599999999999
```
### 总结
第一步：保留两位小数字符串，是正确的！！
第二步：`字符串@"11111.70"`转换为`浮点数`，却多了几位小数。因为 C 语言中，格式化字符串默认 “%f” 默认保留到小数点后第6位。
第三步：通过限制小数点保留具体位数，可以看到浮点数真是面目。


## 二、查看内部存储

[计算机字符编码系统（ASCII，Unicode和UTF）梳理](https://www.jianshu.com/p/d3e3eaa62731)
[编码:隐匿在计算机软硬件背后的语言 笔记](https://www.jianshu.com/p/046c3557f3e4)
[简单理解编码](https://www.jianshu.com/p/da7cc80237f8)
["unicode" 和 "utf-8"](https://www.jianshu.com/p/92f6d4294504)
[计算机程序的思维逻辑 (6) - 如何从乱码中恢复 (上)？](https://mp.weixin.qq.com/s?__biz=MzIxOTI1NTk5Nw==&mid=2650047044&idx=1&sn=92c6a3472baaa70fa542a47c60f76b5d#rd)


在计算机内部，所有数据类型均是以二进制的方式存储。


二进制数的每一个位表示一个计算机位（bit，简称位），8个位组成一个字节(byte)。那么一个字节可以表示256种含义（2^8=256）。 

虽然机器是基于二进制的，但对人类来说，因为二进制数太长了，需要做精简。因此需要将其转换成十六进制（hexadecimal，简称hex）。转换方式很简单，使用“8421法”将四位二进制数转换成十六进制数的一位，比如：1010（binary）会转为A（hex）。在 C 语言中，十六进制数以”0x”或“0X”开头，A表示10，F表示16。 

此后，00000000~11111111就可以用0x00~0xFF来表示了。



|  字符集  | 字符编码 | 简单介绍 |
| - | :--------- | :-------- |
| ASCII | ASCII |单字节，使用了7位 |
| ISO-8859-1 | ISO-8859-1 |也叫Latin-1，单字节，扩展了ASCII，可解码ASCII |
| GB2312 | GB2312 |小于0XFF用单字节，否则用双字节|
| GBK | GBK |扩展GB2312，规则同上，可解码GB2312|
| Unicode | UTF-8 |变长1-6字节|
| Unicode | UTF-16 |双字节|
| Unicode | UTF-32 |定长四字节|





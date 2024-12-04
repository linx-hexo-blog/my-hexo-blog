---
title: iOS中float四舍五入+末尾清零
date: {{ date }}
tags:
- iOS
- 面试题
---

### 一、准备
测试数据
```
float A = 0.124000;
float B = 0.124200;
float C = 0.125000;   （重点关注）
float D = 0.125001;
float E = 0.126000;
```
目的：float保留两位小数显示，四舍五入。


### 二、几种尝试

#### 2.1、最简单的方法
```
NSString * showA = [NSString stringWithFormat:@"%0.2f",X];

// 输出
A = 0.124000;  -->  A = 0.12 
B = 0.124200;  -->  B = 0.12 
C = 0.125000;  -->  C = 0.12
D = 0.125001;  -->  D = 0.13
E = 0.126000;  -->  E = 0.13
```
结果出现了一些偏差。也就是 `float C = 0.125000` 的情况。


#### 2.2、NSDecimalNumber

* 进一步探讨，可查看
[iOS 浮点数的精确计算和四舍五入问题](https://www.jianshu.com/p/946c4c4aff33)

```
/*
枚举
    NSRoundPlain,   // Round up on a tie   貌似取整
    NSRoundDown,    // Always down == truncate   只舍不入
    NSRoundUp,      // Always up     只入不舍
    NSRoundBankers  // on a tie round so last digit is even   貌似四舍五入
*/
NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
scale:2
                                                                                       raiseOnExactness:NO
                                                                                        raiseOnOverflow:NO
                                                                                       raiseOnUnderflow:NO
                                                                                    raiseOnDivideByZero:YES];
NSDecimalNumber * ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:X];
NSDecimalNumber * roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
NSString * showX = [NSString stringWithFormat:@"%@",roundedOunces];

// 输出
A = 0.124000;  -->  A = 0.12 
B = 0.124200;  -->  B = 0.12 
C = 0.125000;  -->  C = 0.12    （重点关注）
C1 = 0.135000; -->  C = 0.14    （重点关注）
D = 0.125001;  -->  D = 0.13
E = 0.126000;  -->  E = 0.13
```

结果同上， `float C = 0.125000` 的情况还不行。

> `NSRoundPlain` 和 `NSRoundBankers` 都不是传统的四舍五入。
1、`NSRoundPlain` 是四舍六进若五前偶数进位奇数舍去。如：1.25 ~ 1.3；1.15 ~ 1.1
2、`NSRoundBankers` 是四舍六进若五前偶数舍去奇数进位。如：1.25 ~ 1.2；1.15 ~ 1.2


#### 2.3、roundf()

```
NSString * showX = [NSString stringWithFormat:@"%0.2f",roundf(X * 100)/100];

// 输出
A = 0.124000;  -->  A = 0.12 
B = 0.124200;  -->  B = 0.12 
C = 0.125000;  -->  C = 0.13
D = 0.125001;  -->  D = 0.13
E = 0.126000;  -->  E = 0.13
```

发现这个方法好像更靠谱点。

**拓展的相关的其他函数**
```
round  如果参数是小数  则求本身的四舍五入.
ceil   如果参数是小数  则求最小的整数但不小于本身.
floor  如果参数是小数  则求最大的整数但不大于本身. 
```


### 三、尾部清零

```
NSString * floatnum = @"0.125000"
NSString * outNumber1 = [NSString stringWithFormat:@"%@",@(floatnum.floatValue)];
```

### 四、项目需求：保留2位小数（四舍五入），末尾如果是零，则不要。

```
+ (NSString *)FloatKeepTwoBitsAndRemoveAllZero:(float)floatnum {
    // 保留2位小数
    NSString * tempfloat = [NSString stringWithFormat:@"%0.2f",roundf(floatnum * 100)/100];
    // 末尾清零
    return [NSString stringWithFormat:@"%@",@(tempfloat.floatValue)];
}
```

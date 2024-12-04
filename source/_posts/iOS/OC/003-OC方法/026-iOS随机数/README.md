---
title: iOS随机数生成
date: {{ date }}
tags:
- iOS
- 面试题
---

# 一、26个字母随机生成32位字符串
```
// 此方法随机产生32位字符串， 修改代码红色数字可以改变 随机产生的位数。
+(NSString *)ret32bitString
{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSStringalloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
```

# 二、产生随机数
- 获取一个随机整数范围在：[0,100)包括0，不包括100
```
int x = arc4random() % 100;
```
- 获取一个随机数范围在：[500,1000），包括500，不包括1000
```
int y = (arc4random() % 501) + 500;
```
- 获取一个随机整数，范围在[from,to），包括from，不包括to
```
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to – from +1)));
}
```










---
title: iOS宏(define)与常量(const)
date: {{ date }}
tags:
- iOS
- 面试题
- define
- const
---



### 参考文档
* [iOS 宏(define)与常量(const)的正确使用](https://www.jianshu.com/p/f83335e036b5)
* [15分钟弄懂 const 和 #define](http://www.cocoachina.com/ios/20160519/16342.html)

>注：配合我的文档[《static、const、extern简介与使用》](https://www.jianshu.com/p/2b0750a77284)一起看更佳！！！

-----
# Part 1 - 理解部分

-----
## 一、什么是const ?
>const是C/C++中的一个关键字(修饰符), const一般用来定义一个常量, 既然叫做常量, 即以后再也不能修改其值.

![const定义常量](003.png)

## 二、什么是#define?
>define, 宏定义, 则是一条预编译指令, 编译器在编译阶段会将所有使用到宏的地方简单地进行替换. 如下图所示 :

![宏定义的替换](004.png)

## 三、他们有什么用?

* const 和 define 都能定义一个常量, 都能实现修改值修改一次, 则所有用上该常量的地方都同步改值, 一句代码都不用改.

* 使代码更易维护

* 提高代码的效率

## 四、他们有什么区别?

* 相同点
  * 都能定义常量

* 不同点
   * **const有修饰功能** ：除了定义常量外，const 还有强大的修饰功能。#define 能增加程序的可读性，有些复杂的功能只需一条宏显示。
  * **类型检查**：const 对数据进行类型检查。#define 无需进行类型检查。定义宏参数时需将参数（）起来。而且调用时参数不应在宏中再做运算。
  * **内存消耗**：const定义常量从汇编的角度来看，只是给出了对应的内存地址，而不是象#define一样给出的是立即数，所以，const定义的常量在程序运行过程中只有一份拷贝，而#define定义的常量在内存中有若干个拷贝，所以宏在程序运行过程中所消耗的内存要比const变量的大得多。

![分配内存](005.png)

   * 编译器通常不为普通const常量分配存储空间，而是将它们保存在符号表中，这使得它成为一个编译期间的常量，没有了存储与读内存的操作，使得它的效率比宏定义要高

* 宏能做到const不能办到的事.
  * 宏能定义函数
  * OC的单例模式用到宏
  * 宏还能根据传入的参数生成字符串, 如下

![image](006.png)




-----
# Part 2 - 实战部分

-----

## 五、define与const使用
你能区分下面的吗？知道什么时候用吗？

```
#define HSCoder @"AAAAAA"
NSString *HSCoder = @"AAAAAA";
extern NSString *HSCoder;
extern const NSString *HSCoder;

static const NSString *HSCoder = @"AAAAAA";

const NSString *HSCoder = @"AAAAAA";
NSString const *HSCoder = @"AAAAAA";
NSString * const HSCoder = @"AAAAAA";
```

### 宏：
```
#define HSCoder @"AAAAAA"
```
### 变量：
```
NSString *HSCoder = @"AAAAAA";
```
### 常量：
四种写法：
```
static const NSString *HSCoder = @"AAAAAA";
const NSString *HSCoder = @"AAAAAA";
NSString const *HSCoder = @"AAAAAA";
NSString * const HSCoder = @"AAAAAA";
```


### 常量区分
* 全局常量：不管你定义在任何文件夹，外部都能访问
```
const NSString *HSCoder = @"AAAAAA";
```
* 局部常量：用static修饰后，不能提供外界访问
```
static const NSString *HSCoder = @"AAAAAA";
```

### const修饰位置不同，代表什么？
```
1.const NSString *HSCoder = @"AAAAAA";
"*HSCoder"不能被修改， "HSCoder"能被修改
2.NSString const *HSCoder = @"AAAAAA";
"*HSCoder"不能被修改， "HSCoder"能被修改
3.NSString * const HSCoder = @"AAAAAA";
"HSCoder"不能被修改，"*HSCoder"能被修改
```

**注意：1和2其实没什么区别**

**结论：const右边的总不能被修改**

**所以一般我们定义一个常量又不想被修改应该这样：**
```
NSString * const HSCoder = @"AAAAAA";
```

## 我的使用


![h文件](001.png)


![m文件](002.png)




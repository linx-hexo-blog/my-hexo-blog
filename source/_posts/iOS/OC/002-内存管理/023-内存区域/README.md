---
title: 内存区域
date: {{ date }}
tags:
- iOS
- 面试题
- 内存
---

iOS 中的内存主要分为五大区域：

Text Segment（代码段）：存储应用程序的代码，包括可执行代码和只读数据。
Data Segment（数据段）：存储应用程序的初始化数据，包括全局变量和静态变量。
Heap（堆）：用于动态分配内存，存储应用程序在运行时创建的对象和数据。
Stack（栈）：用于存储函数调用相关的信息，包括函数参数、返回地址和局部变量。
BSS Segment（未初始化数据段）：存储应用程序的未初始化数据，包括全局变量和静态变量。
栈和堆是两个主要的内存区域，它们有着不同的特点和用途：

栈（Stack）：

栈是一块连续的内存区域，用于存储函数调用相关的信息。
栈的内存是自动分配和释放的，不需要手动管理。
栈上的数据包括函数参数、返回地址、局部变量和函数调用链信息。
栈的大小是固定的，通常在编译时确定。
堆（Heap）：

堆是一块动态分配的内存区域，用于存储应用程序在运行时创建的对象和数据。
堆的内存需要手动管理，使用 malloc、free 等函数来分配和释放内存。
堆上的数据包括动态创建的对象、数组和结构体等。
堆的大小可以动态变化，取决于应用程序的需求。
在 iOS 中，以下数据通常存储在栈上：

函数参数
局部变量
函数返回地址
函数调用链信息
以下数据通常存储在堆上：

动态创建的对象
数组和结构体
字符串和其他动态分配的数据
需要注意的是，iOS 中的内存管理主要使用 ARC（Automatic Reference Counting）机制，ARC 会自动管理堆上的内存，开发者无需手动释放内存。


```c
int a = 10;   // 全局初始化区
char *p;    // 全局未初始化区
 
main {
   int b;   // 栈区
   char s[] = "abc";   // 栈区
   char *p1;   // 栈区
   char *p2 = "123456";   // 123456 在常量区，p2在栈上
   static int c = 0;   // 全局(静态)初始化区
    
   w1 = (char *)malloc(10);
   w2 = (char *)malloc(20);   // 分配得来的10和20字节的区域就在堆区。
}
```
---
title: 简述OC内存管理
date: {{ date }}
tags: [iOS, OC, 内存管理]
---

<!-- # 简述OC内存管理 -->

OC（Objective-C）内存管理主要有两种方式：手动引用计数（Manual Reference Counting，MRC）和自动引用计数（Automatic Reference Counting，ARC）。以下是对这两种内存管理方式的简要介绍：

 <!-- more -->
 
![](duck.jpeg)

## 1. 手动引用计数 (MRC)

在MRC中，开发者需要手动管理对象的内存，通过对对象的引用计数（Reference Counting）来控制其生命周期。主要使用的内存管理方法有：

- **alloc**：分配内存并初始化对象，引用计数设为1。
- **retain**：增加对象的引用计数。
- **release**：减少对象的引用计数，当引用计数为0时，释放对象的内存。
- **autorelease**：将对象添加到自动释放池中，当自动释放池被清空时，调用release方法。

在MRC中，开发者需要小心处理内存的分配和释放，以避免内存泄漏和野指针等问题。

## 2. 自动引用计数 (ARC)

ARC是苹果在iOS 5及Mac OS X Lion中引入的一种内存管理机制。它通过编译器自动插入retain、release和autorelease等方法调用，从而简化内存管理。ARC极大地减少了手动管理内存的负担，降低了内存泄漏和野指针的风险。开发者在使用ARC时，只需关注对象的生命周期，而无需手动调用内存管理方法。

在ARC中，有一些关键规则和概念：
- **strong**：默认属性修饰符，表示对对象的强引用。
- **weak**：表示对对象的弱引用，不增加对象的引用计数，当对象被释放时，weak引用会自动设置为nil。
- **unsafe_unretained**：类似weak，但在对象被释放时不会自动设置为nil，容易导致野指针问题。
- **__autoreleasing**：用于临时对象的自动释放。

## 总结

OC内存管理主要通过引用计数机制来控制对象的生命周期。在MRC中，开发者需要手动管理引用计数，而在ARC中，编译器自动插入内存管理代码，极大简化了内存管理的复杂性。ARC是现代Objective-C开发中推荐的内存管理方式。
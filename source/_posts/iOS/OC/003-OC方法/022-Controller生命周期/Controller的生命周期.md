---
title: Controller的生命周期
date: {{ date }}
tags:
- iOS
- 面试题
- Controller
---



## UIViewController的生命周期及iOS程序执行顺序

* **当一个视图控制器被创建，并在屏幕上显示的时候。 代码的执行顺序**
1、alloc 创建对象，分配空间
2、init (initWithNibName) 初始化对象，初始化数据
3、loadView从nib载入视图，通常这一步不需要去干涉。除非你没有使用xib文件创建视图
4、viewDidLoad载入完成，可以进行自定义数据以及动态创建其他控件
5、viewWillAppear视图将出现在屏幕之前，马上这个视图就会被展现在屏幕上了
6、viewDidAppear视图已在屏幕上渲染完成

* **当一个视图被移除屏幕并且销毁的时候的执行顺序，这个顺序差不多和上面的相反**
1、viewWillDisappear视图将被从屏幕上移除之前执行
2、viewDidDisappear视图已经被从屏幕上移除，用户看不到这个视图了
3、dealloc视图被销毁，此处需要对你在init和viewDidLoad中创建的对象进行释放







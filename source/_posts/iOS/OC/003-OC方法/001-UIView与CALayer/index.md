---
title: iOS中UIView与CALayer
date: {{ date }}
tags:
- iOS
- 面试题
- CALayer
- UIView
---

# 参考

[UIView与CALayer的关系](https://coderlawrence.github.io/2020/03/04/UIView%E4%B8%8ECALayer%E7%9A%84%E5%85%B3%E7%B3%BB/)


# 正文

## UIView继承关系 

首先我们要理解UIView以及它的一个继承关系等

UIView表示屏幕上的一块矩形区域，它是基本上iOS所有可视化控件的父类，UIView可以管理矩形区域里的内容，处理矩形区域的事件，包括对子视图的管理以及动画的实现。

![](001.png)

上面的图是UIKit相关类的继承关系，从上面可以看出，UIView继承自UIResponder，所以UIView可以做事件响应，它也是iOS中所有视图（控件）直接或者间接的父类。

## UIResponder介绍

在UIKit中UIResponder作为响应事件的对象，来响应系统传递过来的事件并进行处理。在UIResponder中定义了处理各种事件传递的接口。
UIApplication、UIViewController、UIView、和所有从UIView派生出来的UIKit类（包括UIWindow）都直接或间接地继承自UIResponder类。
而CALayer直接继承NSObject，并没有相应的处理事件的接口。


## UIView与CALayer的区别

1. UIView能够响应事件，CALayer不可以
2. UIView是CALayer的delegate，当CALayer属性改变、动画产生时，UIView能够得到通知；
3. UIView只是处理事件，CALayer主要负责图层的绘制
4. UIView 和 CALayer 不是线程安全的，并且只能在主线程创建、访问和销毁。
5. 每个UIView内部都有一个CALayer在背后提供内容绘制和显示，而且UIView的尺寸样式都由内部的Layer所提供。两者都有树状层级结构，layer内部有SubLayers，View内部有SubViews。但是Layer比View多了AnchorPoint
6. 一个Layer的frame是由它anchorPoint,position,bounds,和 transform 共同决定的，而一个View的frame只是简单的返回Layer的frame
7. 在iOS做动画的时候，修改非RootLayer的属性（譬如位置、背景色等）会默认产生隐式动画，而修改UIView则不会

8. 常用：向UIView的layer上添加子layer，来使目标View上敷上一层黑色的透明薄膜。
```objc
CALayer *grayCover = [[CALayer alloc] init];
grayCover.backgroudColor = [[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor;
[self.layer addSubLayer: grayCover];
```
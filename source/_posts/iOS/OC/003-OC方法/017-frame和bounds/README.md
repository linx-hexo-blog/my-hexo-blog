---
title: frame 和 bounds
date: {{ date }}
tags:
- iOS
- 面试题
- frame
- bounds
---

[frame和bounds的区别](https://www.jianshu.com/p/964313cfbdaa)

* frame: 该view在父view坐标系统中的位置和大小。（参照点是，父亲的坐标系统）
* bounds：该view在本地坐标系统中的位置和大小。（参照点是，本地坐标系统，就相当于ViewB自己的坐标系统，以0,0点为起点）

<!-- more -->

# frame和bounds简介

![](001.webp)

* frame: 该view在父view坐标系统中的位置和大小。（参照点是，父亲的坐标系统）
* bounds：该view在本地坐标系统中的位置和大小。（参照点是，本地坐标系统，就相当于ViewB自己的坐标系统，以0,0点为起点）。

其实本地坐标系统的关键就是要知道的它的原点（0，0）在父坐标系统中的什么位置（这个位置是相对于父view的本地坐标系统而言的，最终的父view就是UIWindow，它的本地坐标系统原点就是屏幕的左上角了）。

通过修改view的bounds属性可以修改本地坐标系统的原点位置。

# 代码

```
UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
view1.backgroundColor = [UIColor redColor];
[self.view addSubview:view1];//添加到self.view
NSLog(@"view1 frame:%@========view1 bounds:%@",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds));

UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
view2.backgroundColor = [UIColor yellowColor];
[view1 addSubview:view2];//添加到view1上,[此时view1坐标系左上角起点为(-20,-20)]
NSLog(@"view2 frame:%@========view2 bounds:%@",NSStringFromCGRect(view2.frame),NSStringFromCGRect(view2.bounds));
```

![](002.webp)

输出
```
view1 frame:{{100, 100}, {200, 200}}========view1 bounds:{{0, 0}, {200, 200}}
view2 frame:{{0, 0}, {100, 100}}========view2 bounds:{{0, 0}, {100, 100}}
```

下面我们来改变view1的bounds，代码如下

```
[view1 setBounds:CGRectMake(-20, -20, 200, 200)];
```

![](003.webp)

```
view1 frame:{{100, 100}, {200, 200}}========view1 bounds:{{-20, -20}, {200, 200}}
view2 frame:{{0, 0}, {100, 100}}========view2 bounds:{{0, 0}, {100, 100}}
```


# bouns大于frame的情况

假设设置了控件的bounds大于frame，那么此时会导致frame被撑大，frame的x,y,width,height都会改变。

![](004.webp)



# 问：frame 和 bounds 分别是用来做什么的？

* frame是参考父view的坐标系来设置自己左上角的位置。

* 设置bounds可以修改自己坐标系的原点位置，进而影响到其“子view”的显示位置。

* bounds使用场景：

    其实bounds我们一直在使用，就是我们使用scrollview的时候。

    为什么我们滚动scrollview可以看到超出显示屏的内容。就是因为scrollview在不断改变自己的bounds，从而改变scrollview上的子view的frame，让他们的frame始终在最顶级view（window）的frame内部，这样我们就可以始终看到内容了。


# 问：frame 和 bound 一定都相等么？如果有不等的情况，请举例说明

[iOS日常开发之frame和bounds的不同](https://blog.csdn.net/lihao_ios/article/details/107540979)

[2016年3月 iOS 面试总结](https://halfrost.com/ios_interview/)


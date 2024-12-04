---
title: 什么是空指针、野指针？
date: {{ date }}
tags: 
- iOS
- 面试题
- 空指针
- 野指针
---


[【Objective-C】09-空指针和野指针](https://www.cnblogs.com/mjios/archive/2013/04/22/3034788.html)



<!-- # 什么是空指针、野指针？ -->

- 空指针：

    1> 没有存储任何内存地址的指针就称为空指针(NULL指针)

    2> 空指针就是被赋值为0的指针，在没有被具体初始化之前，其值为0。

    ```
    Student *s1 = NULL;
    Student *s2 = nil;
    ```
 <!-- more -->

- 野指针：

    "野指针"不是NULL指针，是指向"垃圾"内存（不可用内存）的指针。野指针是非常危险的。向野指针发送消息会导致崩溃。野指针错误形式在Xcode中通常表现为：Thread 1：EXC_BAD_ACCESS，因为你访问了一块已经不属于你的内存。

- 野指针，有指向，而空指针无指向，为NULL



**空指针**表示指针不指向任何对象或内存，可以安全地检查和处理。

**野指针**指向已经释放或未分配的内存，使用它们会导致未定义行为，需要小心处理。



# 野指针如何产生？

> 1. 指针变量未初始化
>
>     任何指针变量刚被创建时不会自动成为NULL指针，它的缺省值是随机的，它会乱指一气。所以，指针变量在创建的同时应当被初始化，要么将指针设置为NULL，要么让它指向合法的内存。
>
> 2. 指针释放后之后未置空
>
>     有时指针在free或delete后未赋值 NULL，便会使人以为是合法的。别看free和delete的名字（尤其是delete），它们只是把指针所指的内存给释放掉，但并没有把指针本身干掉。此时指针指向的就是“垃圾”内存。释放后的指针应立即将指针置为NULL，防止产生“野指针”。
>
> 3. 指针操作超越变量作用域
>
>     不要返回指向栈内存的指针或引用，因为栈内存在函数结束时会被释放。

**释放对象后没有将指针置为 nil**： 当你手动释放一个对象后，如果没有将指向该对象的指针置为 nil，该指针就变成了野指针。

```
objective
复制代码
MyClass *obj = [[MyClass alloc] init];
[obj release]; // obj 指向的内存被释放了
// obj 现在是野指针
```





示例一：

assign可以用来修饰OC对象，会造成野指针。 unsafe_unretained声明一个弱引用，但不会自动置为nil，会出现野指针。



示例二：

自定义Student类，在main函数中添加下列代码

```objective-c
Student *stu = [[Student alloc] init];

[stu setAge:10];

[stu release];

[stu setAge:10];
```

运行程序，你会发现`[stu setAge:10];`报错了，是个野指针错误！

**分析一下报错原因**

1> 执行完第1行代码后，内存中有个指针变量stu，指向了Student对象 `Student *stu = [[Student alloc] init];`

![img](005.png)

假设Student对象的地址为0xff43，指针变量stu的地址为0xee45，stu中存储的是Student对象的地址0xff43。即指针变量stu指向了这个Student对象。

2> 接下来是第3行代码: `[stu setAge:10];`

这行代码的意思是：给stu所指向的Student对象发送一条setAge:消息，即调用这个Student对象的setAge:方法。目前来说，这个Student对象仍存在于内存中，所以这句代码没有任何问题。

3> 接下来是第5行代码: `[stu release];`

这行代码的意思是：给stu指向的Student对象发送一条release消息。在这里，Student对象接收到release消息后，会马上被销毁，所占用的内存会被回收。

![img](006.png)

Student对象被销毁了，地址为0xff43的内存就变成了"垃圾内存"，然而，指针变量stu仍然指向这一块内存，这时候，stu就称为了**野指针！**

4> 最后执行了第7行代码: `[stu setAge:10];`

这句代码的意思仍然是： 给stu所指向的Student对象发送一条setAge:消息。但是在执行完第5行代码后，Student对象已经被销毁了，它所占用的内存已经是垃圾内存，如果你还去访问这一块内存，那就会报野指针错误。这块内存已经不可用了，也不属于你了，你还去访问它，肯定是不合法的。所以，这行代码报错了！

5> 如果修改下代码： 

```objc
Student *stu = [[Student alloc] init];

[stu setAge:10];

[stu release];

stu = nil;   // stu变成了空指针，stu就不再指向任何内存了

[stu setAge:10];
```

 ![img](007.png)

因为stu是个空指针，没有指向任何对象，因此第9行的setAge:消息是发不出去的，不会造成任何影响。当然，肯定也不会报错。



# 防止野指针的方法

1. **将指针置为 nil**： 在释放对象后，将指针置为 nil 可以防止野指针。

    ```
    objective
    复制代码
    MyClass *obj = [[MyClass alloc] init];
    [obj release];
    obj = nil; // 防止野指针
    ```

2. **使用自动引用计数（ARC）**： ARC 自动管理对象的内存，避免手动管理引用计数，从而减少野指针的产生。

    ```
    objective
    复制代码
    @interface MyClass : NSObject
    @property (nonatomic, strong) NSString *name;
    @end
    
    @implementation MyClass
    @end
    ```

3. **使用弱引用（weak）**： 使用弱引用（weak）来防止循环引用和野指针。弱引用在引用对象被释放后自动置为 nil。

    ```
    objective
    复制代码
    @interface MyClass : NSObject
    @property (nonatomic, weak) id<Delegate> delegate;
    @end
    
    @implementation MyClass
    @end
    ```



# 野指针的定位

[iOS野指针定位总结](https://www.jianshu.com/p/8aba0ee41cd7)

[iOS 通向野指针的必经之路](https://www.jianshu.com/p/a9014c4f379d)

### 检测和调试野指针

1. **启用僵尸对象（Zombie Objects）**： Xcode 提供了启用僵尸对象的选项，可以帮助检测野指针。启用僵尸对象后，被释放的对象会变成僵尸对象，当对僵尸对象发送消息时，会抛出异常，帮助你找到问题所在。

    启用僵尸对象：

    - 选择你的项目。
    - 在左侧栏中选择 “Edit Scheme”。
    - 选择 “Run” 标签，然后选择 “Diagnostics”。
    - 勾选 “Enable Zombie Objects”。

2. **Address Sanitizer**： Address Sanitizer 是一个运行时工具，可以检测内存错误，包括使用野指针。可以在 Xcode 中启用 Address Sanitizer 进行检测。

    启用 Address Sanitizer：

    - 选择你的项目。
    - 在左侧栏中选择 “Edit Scheme”。
    - 选择 “Run” 标签，然后选择 “Diagnostics”。
    - 勾选 “Address Sanitizer”。
---
title: static与extern
date: {{ date }}
tags:
- iOS
- 面试题
- static
- extern
---

static 和 extern 是两个不同的关键字，在 iOS 中它们有着不同的作用：

<!-- more -->

# static

* static 关键字用于修饰变量、函数或块，以限定其作用域。
* 在函数内部，static 变量的生命周期将延长到整个程序的生命周期，而不是函数调用结束后销毁。
* 在文件内部，static 函数或变量只能在该文件内部访问，不能被其他文件访问。
* 在类内部，static 变量或函数属于类的静态成员，而不是实例成员。

示例：

```objc
// 在文件内部定义静态变量
static int counter = 0;

// 在函数内部定义静态变量
void foo() {
    static int x = 0;
    x++;
    printf("%d\n", x);
}

// 在类内部定义静态变量
@interface MyClass : NSObject {
    static int classCounter;
}

@end
```


# extern

extern 关键字用于声明变量或函数的外部链接性，即该变量或函数可以被其他文件访问。
使用 extern 声明的变量或函数必须在其他文件中定义。
extern 可以用于导入其他文件中的变量或函数，以便在当前文件中使用。
示例：

```objc
// 在头文件中声明外部变量
extern int globalCounter;

// 在实现文件中定义外部变量
int globalCounter = 0;

// 在头文件中声明外部函数
extern void foo();

// 在实现文件中定义外部函数
void foo() {
    printf("Hello, world!\n");
}
```

# static extern：

static extern 是一个组合关键字，它的作用是将变量或函数同时声明为静态的和外部可访问的。
使用 static extern 声明的变量或函数只能在当前文件内部访问，但可以被其他文件通过外部链接访问。
示例：

```objc
// 在头文件中声明静态外部变量
static extern int fileCounter;

// 在实现文件中定义静态外部变量
static int fileCounter = 0;
```
需要注意的是，static extern 的使用场景非常少见，因为它限制了变量或函数的访问范围，同时又需要外部链接性。通常情况下，可以使用 extern 或 static 单独来声明变量或函数。


# 自己的理解

（1）extern修饰的全局变量默认是有外部链接的，作用域是整个工程，在一个文件内定义的全局变量，在另一个文件中，通过extern全局变量的声明，就可以使用全局变量。

（2）static修饰全局变量，全局变量的作用域仅限于当前文件；

（3）static修饰局部变量，让局部变量只初始化一次，局部变量在程序中只有一份内存，并不会改变局部变量的作用域，仅仅是改变了局部变量的生命周期（只到程序结束，这个局部变量才会销毁）。

```objc
void test() {
    static int a = 0;
    a++;
    NSLog(@"a = %d", a);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        for (int i = 0; i<3; i++) {
           test();
       }
    }
    return 0;
}

// 输出 1 2 3
```


# 项目中使用

```
// .h
extern NSString *const RCKitDispatchDownloadMediaNotification;


// .m
NSString *const RCKitDispatchDownloadMediaNotification = @"RCKitDispatchDownloadMediaNotification";
```


---
title: iOS中为什么block要用copy修饰？
date: {{ date }}
categories:
- iOS
tags:
- iOS
- 面试题
- block
---

# 参考

- [block为什么要用copy来修饰
](https://coderlawrence.github.io/2020/03/03/block%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E7%94%A8copy/)


# GPT

在 iOS 开发中，`block`（也称为闭包或匿名函数）通常用 `copy` 修饰符进行声明，这是为了确保 `block` 被正确管理和存储。以下是详细的原因：

### 1. **堆内存管理**

在 Objective-C 中，`block` 最初创建时可能是在栈（stack）上分配的，这意味着它的生命周期与它的作用域相同。当栈上的 `block` 超出其作用域时，它将被销毁。如果我们希望在栈外使用该 `block`（例如，存储在属性中或者异步调用），我们需要将其复制到堆（heap）上。

`copy` 修饰符会将栈上的 `block` 复制到堆上，这样可以确保它在需要时仍然存在，不会因为超出作用域而被销毁。

### 2. **ARC 管理**

在自动引用计数（ARC）环境下，`copy` 修饰符还帮助 ARC 正确管理 `block` 的生命周期。ARC 通过 `copy` 操作确保 `block` 在堆上有适当的引用计数，避免内存泄漏或访问已释放的内存。

### 3. **Block 的存储位置**

根据 `block` 的存储位置，它们分为三种类型：

- **栈上的 block**：默认情况下，`block` 在定义时分配在栈上。这些 `block` 的生命周期仅限于其作用域。
- **堆上的 block**：使用 `copy` 操作将栈上的 `block` 复制到堆上，使其生命周期延长。
- **全局 block**：如果 `block` 不捕获任何变量，它会被自动分配在全局数据区，无需 `copy` 操作。

### 示例

以下是一个示例，说明为什么需要使用 `copy` 修饰符：

```objc
#import <Foundation/Foundation.h>

typedef void (^MyBlock)(void);

@interface MyClass : NSObject
@property (nonatomic, copy) MyBlock myBlock;
@end

@implementation MyClass
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyClass *myObject = [[MyClass alloc] init];
        int someVar = 42;
        
        // 定义一个 block，捕获 someVar 变量
        myObject.myBlock = ^{
            NSLog(@"Captured variable: %d", someVar);
        };
        
        // 在稍后时间调用 block
        myObject.myBlock();
    }
    return 0;
}
```

在上述代码中，如果我们将 `myBlock` 属性定义为 `strong` 或 `assign` 而不是 `copy`，则该 `block` 可能仍然在栈上，当超出作用域时，它将被销毁，从而导致潜在的崩溃或未定义行为。通过将其定义为 `copy`，我们确保 `block` 被正确地复制到堆上，延长其生命周期并保证其安全性。

### 总结

使用 `copy` 修饰符确保 `block` 在堆上存储，以管理其生命周期，避免内存管理问题，并确保在合适的时机正确使用 `block`。这是 iOS 开发中确保 `block` 正确工作和避免潜在问题的重要实践。
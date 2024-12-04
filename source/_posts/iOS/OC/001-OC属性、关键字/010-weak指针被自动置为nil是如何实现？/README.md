---
title: 对象回收时 weak 指针自动被置为 nil 是如何实现的？
date: {{ date }}
tags:
- iOS
- 面试题
- weak
---

<!-- # 对象回收时 weak 指针自动被置为 nil 是如何实现的？ -->

在 iOS的自动引用计数（ARC）机制中，当对象被回收时，所有指向该对象的 `__weak` 指针都会被自动置为 `nil`。这个功能是通过Objective-C运行时（runtime）的弱引用表（weak reference table）实现的。以下是实现这一功能的详细机制：

<!-- more -->

### 1. 弱引用表（Weak Reference Table）

Objective-C运行时维护了一张全局的弱引用表，这张表记录了所有的弱引用。当创建一个弱引用时，这个弱引用会被添加到弱引用表中。

### 2. 创建弱引用

当你创建一个弱引用时，例如：

```objective-c
__weak MyClass *weakRef = strongRef;
```

ARC 会在弱引用表中添加一个条目，记录 `weakRef` 指向的对象地址以及 `weakRef` 本身的地址。这个条目让运行时知道哪些弱引用指向了某个对象。

### 3. 对象销毁

当一个对象的引用计数降到零时，ARC 会释放这个对象。在释放对象之前，运行时会查阅弱引用表，找到所有指向这个对象的弱引用，并将它们置为 `nil`。

### 4. 实现细节

具体实现涉及以下步骤：

- **添加弱引用**：
  当创建弱引用时，ARC 通过调用 `objc_storeWeak` 函数将弱引用存储在弱引用表中。

- **释放对象**：
  当对象引用计数降到零时，ARC 通过调用 `objc_release` 函数来处理对象的释放。在释放之前，会调用 `clearDeallocating` 函数。

- **清理弱引用**：
  `clearDeallocating` 函数会查找弱引用表中所有指向即将销毁的对象的弱引用，并将它们置为 `nil`。这个过程包括以下步骤：
  - 查找弱引用表中的条目。
  - 将每个弱引用的值设置为 `nil`。
  - 从弱引用表中移除这些条目。

### 代码示例

以下是一个简单的示例，演示了弱引用自动置为 `nil` 的行为：

```objective-c
#import <Foundation/Foundation.h>

@interface MyClass : NSObject
@end

@implementation MyClass
- (void)dealloc {
    NSLog(@"MyClass instance is being deallocated");
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyClass *strongRef = [[MyClass alloc] init];
        __weak MyClass *weakRef = strongRef;
        
        NSLog(@"Before setting strongRef to nil: weakRef = %@", weakRef);
        
        strongRef = nil; // MyClass instance is deallocated
        
        NSLog(@"After setting strongRef to nil: weakRef = %@", weakRef);
    }
    return 0;
}
```

输出：

```
Before setting strongRef to nil: weakRef = <MyClass: 0x100508ee0>
MyClass instance is being deallocated
After setting strongRef to nil: weakRef = (null)
```

### 内部机制

以下是一些关键函数和概念，用于实现弱引用自动置为 `nil` 的机制：

- **objc_storeWeak**：
  这个函数用于存储弱引用，并在弱引用表中注册这个弱引用。

- **clearDeallocating**：
  当对象引用计数降到零时，这个函数会被调用，用于清理弱引用表中的条目。

- **弱引用表**：
  运行时维护的全局哈希表，用于存储所有弱引用的地址和它们指向的对象。

### 总结

弱引用自动置为 `nil` 的机制是通过 Objective-C 运行时的弱引用表实现的。当对象被回收时，运行时会查找并清理所有指向该对象的弱引用，将它们置为 `nil`。这个机制确保了弱引用不会悬挂，避免了潜在的崩溃和未定义行为。理解这一机制有助于更好地掌握 ARC 和内存管理。
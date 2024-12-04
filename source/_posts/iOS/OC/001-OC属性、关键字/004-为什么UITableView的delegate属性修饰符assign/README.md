---
title: 为什么UITableView的delegate属性修饰符assign
date: {{ date }}
tags: [iOS, 面试题, delegate, UITableView, assign]
---

<!-- # 为什么UITableView的delegate属性修饰符assign -->

在早期的 iOS 开发中，`UITableView` 的 `delegate` 属性使用 `assign` 修饰符是为了避免循环引用（retain cycle）。以下是详细解释：

<!-- more -->

### 循环引用问题

`delegate` 通常用于代理模式，这种模式在 iOS 开发中非常常见。代理对象通常是视图控制器，而被代理的对象是视图组件（如 `UITableView`）。如果 `delegate` 属性使用 `strong` 或 `retain`，会导致以下循环引用：

- 视图控制器（ViewController）持有 `UITableView` 对象的强引用。
- `UITableView` 对象又通过 `delegate` 属性持有视图控制器的强引用。

这样，两者之间互相持有对方的强引用，导致内存无法释放，形成循环引用（retain cycle）。

### 使用 `assign` 修饰符

为了解决这个问题，`delegate` 属性在早期使用 `assign` 修饰符：

```objective-c
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
```

- **assign**：直接赋值，不更改引用计数。这样 `UITableView` 对象对 `delegate`（通常是视图控制器）的引用不会增加引用计数，从而避免了循环引用。

### 从 `assign` 到 `weak`

在ARC（Automatic Reference Counting）引入之后，苹果推荐使用 `weak` 修饰符来代替 `assign`。`weak` 属性不仅可以避免循环引用，还能在目标对象被释放时自动将指针置为 `nil`，避免悬空指针（dangling pointer）的问题。

因此，现代的 iOS 开发中，`UITableView` 的 `delegate` 属性一般使用 `weak` 修饰符：

```objective-c
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
```

这样，`UITableView` 对 `delegate` 的引用不会增加引用计数，并且在 `delegate` 被释放时自动置为 `nil`，更加安全。

### 总结

- 早期的 `delegate` 属性使用 `assign` 是为了避免循环引用，防止内存泄漏。
- ARC 引入后，推荐使用 `weak` 修饰符，既避免循环引用，又防止悬空指针问题。

因此，在现代 iOS 开发中，`UITableView` 和其他视图组件的 `delegate` 属性通常使用 `weak` 修饰符。
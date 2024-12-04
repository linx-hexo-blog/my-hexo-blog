---
title: 请问 @property 的本质是什么？
date: {{ date }}
tags: [iOS, 面试题, property]
---

<!-- # @property 的本质是什么？ -->

在 Objective-C 中，`@property` 是一种用于声明类的属性的语法糖。**它的本质是帮助开发者自动生成属性的 getter 和 setter 方法，以及属性所需的实例变量（ivar）。**`@property` 使得代码更简洁、可读性更高，并且减少了手动编写 getter 和 setter 方法的繁琐工作。为了更详细地理解 `@property` 的本质，下面从几个方面进行解释：

<!-- more -->

### `@property` 的基本组成部分

当你在类中声明一个属性时：

```objective-c
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *name;

@end
```

`@property` 包含以下几个部分：

- **属性特性（Attributes）**：如 `nonatomic`、`strong`，用于指定属性的行为。
- **类型（Type）**：如 `NSString *`，指定属性的数据类型。
- **属性名（Name）**：如 `name`，指定属性的名称。

### `@property` 的工作原理

在编译时，`@property` 会生成与之相关的实例变量、getter 和 setter 方法。以上面的例子为例，`@property (nonatomic, strong) NSString *name;` 将生成以下内容：

#### 1. 实例变量

编译器生成一个名为 `_name` 的实例变量（ivar）：

```objective-c
@interface MyClass : NSObject {
    NSString *_name;
}
```

#### 2. Getter 方法

编译器生成一个名为 `name` 的 getter 方法：

```objective-c
- (NSString *)name {
    return _name;
}
```

#### 3. Setter 方法

编译器生成一个名为 `setName:` 的 setter 方法：

```objective-c
- (void)setName:(NSString *)newName {
    if (_name != newName) {
        [_name release];
        _name = [newName retain];
    }
}
```

### `@property` 的属性特性

`@property` 可以通过属性特性来控制生成的 getter 和 setter 的行为。常用的属性特性包括：

- **atomic / nonatomic**：决定属性的原子性。`atomic` 保证多线程环境下的安全，但性能较低；`nonatomic` 性能较高，但不保证线程安全。
- **strong / weak / assign / copy**：指定属性的内存管理语义。
- **readonly / readwrite**：指定属性是否只读。默认是 `readwrite`，可以生成 getter 和 setter；`readonly` 只生成 getter。
- **getter / setter**：指定自定义的 getter 和 setter 方法名。

```objective-c
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) id<Delegate> delegate;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) NSString *identifier;
@property (getter=isValid, setter=setValid:) BOOL valid;
```

### 实例分析

假设你有以下代码：

```objective-c
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *identifier;

@end

@implementation MyClass

@synthesize name = _name; // 手动指定实例变量名
@synthesize identifier = _identifier; // 手动指定只读属性的实例变量名

@end
```

这段代码：

1. 为 `name` 属性生成 `_name` 实例变量、getter 和 setter 方法。
2. 为 `identifier` 属性生成 `_identifier` 实例变量和 getter 方法。

如果没有使用 `@synthesize`，编译器会自动合成这些方法和实例变量。

### 总结

`@property` 的本质是一个语法糖，它在编译时自动生成与属性相关的实例变量、getter 和 setter 方法。通过使用 `@property`，开发者可以简化代码，提高可读性和可维护性。理解 `@property` 的本质和工作原理，有助于更好地掌握 Objective-C 的内存管理和编程技巧。
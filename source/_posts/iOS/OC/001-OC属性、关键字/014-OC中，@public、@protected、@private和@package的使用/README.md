---
title: iOS中@public、@protected、@private、@package怎么用？
date: {{ date }}
tags:
- iOS
- 面试题
- 访问权限
---

<!-- # ios 中@public，@protected，@private，@package 怎么用 -->

在 Objective-C 中，`@public`、`@protected`、`@private` 和 `@package` 是用来定义类成员变量（instance variables）的访问权限的关键字。它们用于控制类成员变量的可见性和访问权限。这些关键字在类的接口部分或实现部分的 `{}` 中使用。下面是它们的用法和区别。

<!-- more -->

### `@public`

`@public` 关键字使成员变量在类的外部可见和可访问。任何对象都可以直接访问 `@public` 成员变量。

#### 示例

```objc
@interface MyClass : NSObject {
    @public
    NSString *publicString;
}

@end

@implementation MyClass
@end

MyClass *obj = [[MyClass alloc] init];
obj->publicString = @"Public String"; // 直接访问 public 成员变量
NSLog(@"%@", obj->publicString);
```

### `@protected`

`@protected` 是默认的访问权限。`@protected` 成员变量只能在类的内部或子类中访问，但不能在类的外部访问。

#### 示例

```objc
@interface MyClass : NSObject {
    @protected
    NSString *protectedString;
}

@end

@implementation MyClass
@end

@interface SubClass : MyClass
- (void)accessProtectedString;
@end

@implementation SubClass
- (void)accessProtectedString {
    self->protectedString = @"Protected String"; // 子类可以访问 protected 成员变量
}
@end

MyClass *obj = [[MyClass alloc] init];
// obj->protectedString = @"Protected String"; // 编译错误，类的外部不能访问 protected 成员变量
```

### `@private`

`@private` 成员变量只能在定义它们的类的内部访问，子类和外部类都不能访问。

#### 示例

```objc
@interface MyClass : NSObject {
    @private
    NSString *privateString;
}

@end

@implementation MyClass
- (void)accessPrivateString {
    self->privateString = @"Private String"; // 类的内部可以访问 private 成员变量
}
@end

@interface SubClass : MyClass
- (void)accessPrivateString;
@end

@implementation SubClass
- (void)accessPrivateString {
    // self->privateString = @"Private String"; // 编译错误，子类不能访问 private 成员变量
}
@end

MyClass *obj = [[MyClass alloc] init];
// obj->privateString = @"Private String"; // 编译错误，类的外部不能访问 private 成员变量
```

### `@package`

`@package` 成员变量的访问权限类似于 `@protected`，但是在同一个包（framework）中的所有类都可以访问这些成员变量。这在开发大型应用或框架时非常有用。

#### 示例

```objc
@interface MyClass : NSObject {
    @package
    NSString *packageString;
}

@end

@implementation MyClass
@end

// 假设此类在同一个包中
@interface AnotherClass : NSObject
- (void)accessPackageString:(MyClass *)obj;
@end

@implementation AnotherClass
- (void)accessPackageString:(MyClass *)obj {
    obj->packageString = @"Package String"; // 同一个包中的类可以访问 package 成员变量
}
@end

MyClass *obj = [[MyClass alloc] init];
// obj->packageString = @"Package String"; // 编译错误，不在同一个包中的类不能访问 package 成员变量
```

### 总结

- **`@public`**：任何地方都可以访问。
- **`@protected`**：只有类的内部和子类可以访问。
- **`@private`**：只有类的内部可以访问。
- **`@package`**：同一个包（framework）中的类可以访问。

这些关键字帮助开发者更好地控制类成员变量的访问权限，确保数据的封装和安全性。
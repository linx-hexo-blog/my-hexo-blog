---
title: 请问 @synthesize 和 @dynamic 分别有什么作用？
date: {{ date }}
tags: [iOS, 面试题, synthesize, dynamic]
---

<!-- # @synthesize 和 @dynamic 分别有什么作用？ -->

在 Objective-C 中，`@synthesize` 和 `@dynamic` 是用来辅助属性（`@property`）的实现的关键字。它们在处理属性的 getter 和 setter 方法时具有不同的作用和用途。

<!-- more -->

### `@synthesize`

`@synthesize` 用于自动生成属性的 getter 和 setter 方法。如果你不手动实现这些方法，编译器会根据 `@synthesize` 来生成默认的实现。使用 `@synthesize` 时，你还可以指定属性的实例变量名。

```objective-c
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation MyClass

// 自动生成 _name 实例变量、getter 和 setter 方法
@synthesize name = _name;

@end
```

#### 作用
- **自动生成 getter 和 setter 方法**：`@synthesize` 告诉编译器自动为属性生成相应的 getter 和 setter 方法。
- **指定实例变量名**：可以用 `@synthesize propertyName = instanceVariableName` 的形式来指定属性对应的实例变量名。

#### 默认行为
如果不显式使用 `@synthesize`，编译器会默认合成实例变量和相应的 getter、setter 方法：

```objective-c
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation MyClass

// 默认情况下，编译器会自动生成 _name 实例变量和方法

@end
```

### `@dynamic`

`@dynamic` 告诉编译器不要自动生成属性的 getter 和 setter 方法，开发者需要在运行时动态地提供这些方法的实现。通常用于 Core Data 或其他需要在运行时动态处理属性的场景。

```objective-c
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation MyClass

@dynamic name;

@end
```

#### 作用
- **禁用自动生成**：`@dynamic` 禁用编译器对属性自动生成的 getter 和 setter 方法。
- **运行时提供实现**：开发者需要在运行时通过手动实现或其他方式提供 getter 和 setter 方法。

#### 使用场景
- **Core Data**：在使用 Core Data 时，属性的实现通常由 Core Data 动态提供，而不是由编译器自动生成。
- **动态方法解析**：在某些高级用例中，开发者可能需要使用 `@dynamic` 并手动实现 `resolveInstanceMethod:` 或消息转发机制。

### 总结

- **`@synthesize`**：
  - 用于自动生成属性的 getter 和 setter 方法。
  - 可以指定属性的实例变量名。
  - 如果不显式使用，编译器会默认合成。

- **`@dynamic`**：
  - 告诉编译器不要自动生成 getter 和 setter 方法。
  - 需要在运行时动态提供方法的实现。
  - 通常用于 Core Data 或其他需要动态处理属性的场景。

通过理解 `@synthesize` 和 `@dynamic` 的作用和使用场景，开发者可以更灵活地管理属性的实现，满足不同的编程需求。
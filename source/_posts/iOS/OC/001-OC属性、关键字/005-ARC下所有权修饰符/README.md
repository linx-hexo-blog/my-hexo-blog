---
title: iOS ARC 下 所有权修饰符
date: {{ date }}
tags: [iOS, 面试题, 修饰符]
---

<!-- # iOS ARC 下 所有权修饰符 -->

在 iOS 的 ARC（Automatic Reference Counting）环境下，所有权修饰符用于指定对象的内存管理策略。ARC 自动处理对象的引用计数，但开发者可以通过使用这些修饰符来显式地控制对象的生命周期和内存管理。以下是常用的 ARC 所有权修饰符及其详细解释：
 
<!-- more -->

### 1. `__strong`
- **作用**：表示对对象的强引用，持有对象。对象的引用计数会增加，直到所有对它的 `strong` 引用都被释放，才会被销毁。
- **默认行为**：在 ARC 环境中，默认情况下所有对象都是 `__strong`，即使不显式声明。
- **使用场景**：适用于需要长期持有的对象，如模型对象、视图控制器的子视图等。

```objective-c
// 默认情况下，所有对象都是 __strong
__strong NSString *name = [[NSString alloc] init];
```

### 2. `__weak`
- **作用**：表示对对象的弱引用，不持有对象。对象的引用计数不会增加，当对象被销毁时，weak 属性会自动设置为 nil，避免悬空指针（dangling pointer）。
- **使用场景**：用于避免循环引用（如 `delegate`、`IBOutlet`）。

```objective-c
// 使用 __weak 避免循环引用
__weak id<Delegate> delegate = self.delegate;
```

### 3. `__unsafe_unretained`
- **作用**：类似于 `__weak`，但对象被销毁时不会自动设置为 nil，可能导致悬空指针。适用于不支持弱引用的对象。
- **使用场景**：在特定情况下需要使用非 ARC 环境下不需要弱引用的对象，但需要小心避免悬空指针。

```objective-c
// 使用 __unsafe_unretained，可能导致悬空指针
__unsafe_unretained id delegate = self.delegate;
```

### 4. `__autoreleasing`
- **作用**：表示对象会被放入自动释放池中，在当前作用域结束时被释放。通常用于方法参数和返回值，以确保临时对象被自动释放。
- **使用场景**：在处理 `NSError` 和其他双指针参数（如 `id *`）时。

```objective-c
- (BOOL)performOperationWithError:(NSError * __autoreleasing *)error {
    if (/* some failure condition */) {
        if (error) {
            *error = [NSError errorWithDomain:@"com.example" code:42 userInfo:nil];
        }
        return NO;
    }
    return YES;
}
```

### 示例代码
以下示例展示了 `__strong`、`__weak`、`__unsafe_unretained` 和 `__autoreleasing` 的使用：

```objective-c
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *strongName;
@property (nonatomic, weak) id<Delegate> weakDelegate;
@property (nonatomic, unsafe_unretained) id unsafeDelegate;

- (BOOL)performOperationWithError:(NSError * __autoreleasing *)error;

@end

@implementation MyClass

- (void)example {
    // __strong 变量，持有对象
    __strong NSString *strongString = [[NSString alloc] initWithString:@"Hello"];
    
    // __weak 变量，不持有对象，当对象被销毁时自动设置为 nil
    __weak NSString *weakString = strongString;
    
    // __unsafe_unretained 变量，不持有对象，当对象被销毁时不会自动设置为 nil
    __unsafe_unretained NSString *unsafeString = strongString;
    
    NSLog(@"strongString: %@", strongString);
    NSLog(@"weakString: %@", weakString);
    NSLog(@"unsafeString: %@", unsafeString);
}

- (BOOL)performOperationWithError:(NSError * __autoreleasing *)error {
    if (/* some failure condition */) {
        if (error) {
            *error = [NSError errorWithDomain:@"com.example" code:42 userInfo:nil];
        }
        return NO;
    }
    return YES;
}

@end
```

### 总结
- **`__strong`**：默认行为，适用于大多数场景，确保对象被持有。
- **`__weak`**：用于避免循环引用，适用于 `delegate`、`IBOutlet` 等。
- **`__unsafe_unretained`**：需要小心使用，避免悬空指针。推荐在 ARC 环境下尽量使用 `__weak` 代替。
- **`__autoreleasing`**：用于方法参数和返回值，确保临时对象被自动释放。
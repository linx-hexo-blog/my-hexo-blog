---
title: iOS中 Core Foundation 不支持 ARC
date: {{ date }}
tags: [iOS, 面试题, ARC]
---

<!-- # iOS中 Core Foundation 不支持 ARC -->

Core Foundation（CF）是一个底层的C语言框架，用于iOS和macOS开发。它不支持自动引用计数（ARC），因此在使用Core Foundation的API时，开发者需要手动管理内存。
 
<!-- more -->

### Core Foundation 与 ARC

在使用Core Foundation的对象时，以下几点需要特别注意：

1. **手动管理内存**：与Objective-C对象不同，Core Foundation对象必须手动管理其生命周期。这意味着需要手动调用`CFRetain`和`CFRelease`来管理对象的引用计数。

2. **内存管理规则**：Core Foundation遵循特定的内存管理规则，如Create Rule和Get Rule。
   - **Create Rule**：任何带有`Create`或`Copy`的函数（例如`CFStringCreateWithCString`）会返回一个新创建的对象，调用者负责管理其生命周期，并在不需要时调用`CFRelease`。
   - **Get Rule**：任何不带有`Create`或`Copy`的函数（例如`CFArrayGetValueAtIndex`）返回的对象由调用者不负责管理。

3. **桥接 Core Foundation 和 Objective-C 对象**：Core Foundation对象和Objective-C对象之间的转换需要桥接，通常通过`__bridge`、`__bridge_retained`、`__bridge_transfer`来实现。

### 桥接示例

以下是一些常见的桥接示例，用于在Core Foundation和Objective-C对象之间转换，并管理内存：

#### 将 Core Foundation 对象转换为 Objective-C 对象

如果需要将Core Foundation对象转换为Objective-C对象，并且希望ARC管理Objective-C对象的生命周期，可以使用`__bridge_transfer`。

```objective-c
CFStringRef cfString = CFStringCreateWithCString(NULL, "Hello, World!", kCFStringEncodingUTF8);
NSString *objcString = (__bridge_transfer NSString *)cfString;
// objcString 将被 ARC 管理，不需要手动调用 CFRelease(cfString)
```

#### 将 Objective-C 对象转换为 Core Foundation 对象

如果需要将Objective-C对象转换为Core Foundation对象，并且希望手动管理Core Foundation对象的生命周期，可以使用`__bridge_retained`。

```objective-c
NSString *objcString = @"Hello, World!";
CFStringRef cfString = (__bridge_retained CFStringRef)objcString;
// 需要手动调用 CFRelease(cfString) 来释放内存
CFRelease(cfString);
```

### 完整示例

以下是一个完整示例，演示了在ARC环境下如何使用Core Foundation对象，并正确地进行内存管理：

```objective-c
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

void createAndUseCoreFoundationObject() {
    // 创建 Core Foundation 对象
    CFStringRef cfString = CFStringCreateWithCString(NULL, "Hello, World!", kCFStringEncodingUTF8);
    
    // 将 Core Foundation 对象转换为 Objective-C 对象
    NSString *objcString = (__bridge_transfer NSString *)cfString;
    NSLog(@"Objective-C String: %@", objcString);
    
    // Core Foundation 对象被 ARC 管理，不需要手动释放
}

void convertAndManageObjectiveCObject() {
    // 创建 Objective-C 对象
    NSString *objcString = @"Hello, World!";
    
    // 将 Objective-C 对象转换为 Core Foundation 对象
    CFStringRef cfString = (__bridge_retained CFStringRef)objcString;
    
    // 使用 Core Foundation 对象
    CFShow(cfString);
    
    // 手动释放 Core Foundation 对象
    CFRelease(cfString);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        createAndUseCoreFoundationObject();
        convertAndManageObjectiveCObject();
    }
    return 0;
}
```

### 总结

Core Foundation不支持ARC，因此在使用Core Foundation对象时，开发者需要手动管理内存。这包括遵循Create Rule和Get Rule，以及正确地使用桥接来转换Core Foundation和Objective-C对象。理解这些规则和技巧，有助于在ARC环境中正确、安全地使用Core Foundation。





# 关于 Toll-Free Bridging

- __bridge（修饰符）
- __bridge_retained（修饰符） or CFBridgingRetain（函数）
- __bridge_transfer（修饰符） or CFBridgingRelease（函数）

https://www.samirchen.com/ios-arc/
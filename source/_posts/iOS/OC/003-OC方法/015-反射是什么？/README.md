---
title: 反射是什么？
date: {{ date }}
tags:
- iOS
- 面试题
- 反射
---

在iOS开发中，反射（Reflection）是指在运行时动态检查和操作对象、类型、属性和方法的能力。通过反射，你可以在代码中动态地获取类型信息、调用方法、访问属性等，而无需在编译时知道这些信息。

<!-- more -->

获取Class的三种方法

```
// 通过字符串获取class  
Class class = NSClassFromString(@"NSString");  
NSLog(@"class type : %@", class);  


// 直接用class 来创建对象 ,通过对象来获取class 
id str = [[class alloc] init];   
NSLog(@"%@", [str class]);  


// 通过类来获取class  
NSLog(@"%d", class==NSString.class);   
```


常用判断方法

```
// 当前对象是否这个类或其子类的实例
- (BOOL)isKindOfClass:(Class)aClass;

// 当前对象是否是这个类的实例
- (BOOL)isMemberOfClass:(Class)aClass;

// 当前对象是否遵守这个协议
- (BOOL)conformsToProtocol:(Protocol *)aProtocol;

// 当前对象是否实现这个方法
- (BOOL)respondsToSelector:(SEL)aSelector;
```


# GPT 

在iOS开发中，反射（Reflection）是指在运行时动态检查和操作对象、类型、属性和方法的能力。通过反射，你可以在代码中动态地获取类型信息、调用方法、访问属性等，而无需在编译时知道这些信息。

### 反射的常见用途

1. **动态类型检查**：在运行时检查对象的类型。
2. **动态方法调用**：在运行时调用对象的方法。
3. **动态属性访问**：在运行时访问对象的属性。
4. **序列化和反序列化**：将对象转换为可传输格式（如JSON），或将传输格式转换回对象。

### Objective-C中的反射

Objective-C由于其动态特性，支持广泛的反射操作。常用的反射相关方法和类包括：

- `NSObject`类的方法：
  - `class`
  - `superclass`
  - `isKindOfClass:`
  - `isMemberOfClass:`
  - `respondsToSelector:`
  - `performSelector:`
  - `conformsToProtocol:`
- `NSClassFromString`
- `NSStringFromClass`
- `NSSelectorFromString`
- `NSStringFromSelector`

#### 示例：动态类型检查和方法调用

```objective-c
#import <Foundation/Foundation.h>

@interface MyClass : NSObject
- (void)sayHello;
@end

@implementation MyClass
- (void)sayHello {
    NSLog(@"Hello, World!");
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 动态创建类实例
        Class myClass = NSClassFromString(@"MyClass");
        id myObject = [[myClass alloc] init];
        
        // 动态检查类型
        if ([myObject isKindOfClass:myClass]) {
            NSLog(@"myObject is kind of MyClass");
        }
        
        // 动态调用方法
        SEL selector = NSSelectorFromString(@"sayHello");
        if ([myObject respondsToSelector:selector]) {
            [myObject performSelector:selector];
        }
    }
    return 0;
}
```

**输出：**

```
myObject is kind of MyClass
Hello, World!
```

在这个示例中，`NSClassFromString`用于动态获取类，`NSSelectorFromString`用于动态获取方法选择器，`performSelector:`用于动态调用方法。

### Swift中的反射

Swift也支持反射，但由于其更强的类型安全和编译时检查，Swift的反射功能比Objective-C有限。Swift提供了`Mirror`类型来进行反射操作。

#### 示例：使用`Mirror`进行反射

```swift
import Foundation

class MyClass {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func sayHello() {
        print("Hello, World!")
    }
}

let myObject = MyClass(name: "John", age: 30)

// 使用Mirror进行反射
let mirror = Mirror(reflecting: myObject)
for child in mirror.children {
    if let label = child.label {
        print("\(label): \(child.value)")
    }
}
```

**输出：**

```
name: John
age: 30
```

在这个示例中，`Mirror`用于反射`myObject`的属性和值。需要注意的是，Swift的反射功能更注重属性的获取，而不是动态方法调用。

### 总结

反射在iOS开发中提供了强大的动态能力，允许在运行时检查和操作对象的类型、属性和方法。Objective-C提供了广泛的反射功能，而Swift也提供了基本的反射能力，主要用于属性的获取和操作。在实际开发中，合理使用反射可以提高代码的灵活性和适应性，但过度使用反射可能会影响性能和代码的可维护性。


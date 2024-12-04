---
title: 怎么用 copy 关键字？
date: {{ date }}
tags:
- iOS
- 面试题
- copy
---

<!-- # 怎么用 copy 关键字？ -->

* NSString、NSArray、NSDictionary等等经常使用copy关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary，为确保对象中的属性值不会无意间变动，应该在设置新属性值时拷贝一份，保护其封装性
* block也经常使用copy关键字
    * block 使用 copy 是从 MRC 遗留下来的“传统”,在 MRC 中,方法内部的 block 是在栈区的,使用 copy 可以把它放到堆区.
    * 在ARC中写不写都行：对于 block 使用 copy 还是 strong 效果是一样的，但是建议写上copy，因为这样显示告知调用者“编译器会自动对 block 进行了 copy 操作”


<!-- more -->


假如有一个NSMutableString,现在用他给一个retain修饰 NSString赋值,那么只是将NSString指向了NSMutableString所指向的位置,并对NSMUtbaleString计数器加一,此时,如果对NSMutableString进行修改,也会导致NSString的值修改,原则上这是不允许的. 如果是copy修饰的NSString对象,在用NSMutableString给他赋值时,会进行深拷贝,及把内容也给拷贝了一份,两者指向不同的位置,即使改变了NSMutableString的值,NSString的值也不会改变.

所以用copy是为了安全,防止NSMutableString赋值给NSString时,前者修改引起后者值变化而用的.



strong修饰NSString

```objective-c
@property (nonatomic, strong) NSString *name;

- (void)string_strong {
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];

    self.name = mStr;

    NSLog(@"使用strong第一次得到的名字：%@", self.name);

    [mStr appendString:@"丰"];

    NSLog(@"使用strong第二次得到的名字：%@", self.name);
}

// 输出
使用strong第一次得到的名字：张三
使用strong第二次得到的名字：张三丰
```





copy修饰NSString

```objective-c
@property (nonatomic, copy) NSString *title;

- (void)string_copy {
    
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];

    self.title = mStr;

    NSLog(@"使用copy第一次得到的名字：%@", self.title);

    [mStr appendString:@"丰"];

    NSLog(@"使用copy第二次得到的名字：%@", self.title);
}

// 输出
使用copy第一次得到的名字：张三
使用copy第二次得到的名字：张三
```





# 这个写法会出什么问题：@property (copy) NSMutableArray *arr;

1. atomic 属性会影响性能；
2. 由于copy复制了一个不可变的NSArray对象，如果对arr进行添加、删除、修改数组内部元素的时候，程序找不到对应的方法而崩溃；



```objc
@property (nonatomic, copy) NSMutableString *testStr;

- (void)mutableString_copy {
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];

    self.testStr = mStr;

    NSLog(@"使用copy第一次得到的名字：%@", self.testStr);

    [mStr appendString:@"丰"];

    NSLog(@"使用copy第二次得到的名字：%@", self.testStr);
    
    [self.testStr appendString:@"123"];
    
    NSLog(@"使用copy第三次得到的名字：%@", self.testStr);
}

// 输出
使用copy第一次得到的名字：张三
使用copy第一次得到的名字：张三
Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Attempt to mutate immutable object with appendString:'.........

// 崩溃原因
由于copy复制了一个不可变的NSArray对象，如果对arr进行添加、删除、修改数组内部元素的时候，程序找不到对应的方法而崩溃。
```





# 如何让自己的类用 copy 修饰符？

1. 需要声明该类遵从NSCopying 或 NSMutableCopying协议；

2. 实现NSCopying协议，该协议只有一个方法：`-(id)copyWithZone:(NSZone *)zone;`

* **拓展**

    copy：不可变拷贝,遵循NSCopying协议，需要对应实现copyWithZone方法；

    mutableCopy：可变拷贝，遵循NSMutableCopying协议，需要对应实现mutableCopyWithZone:方法；





# 对于深拷贝和浅拷贝的理解

系统对象 NSString/NSMutableString/NSArray/NSMutableArray 的 copy 与 mutableCopy 方法。



在 iOS 开发中，`NSString`、`NSMutableString`、`NSArray` 和 `NSMutableArray` 都是非常常用的对象。这些对象都有 `copy` 和 `mutableCopy` 方法，用于创建不可变副本或可变副本。理解这些方法的行为对于正确处理对象的拷贝和内存管理至关重要。

### `copy` 与 `mutableCopy` 方法

- **`copy`**：创建对象的不可变副本。如果对象本身是不可变的，那么 `copy` 方法通常会返回对象本身。
- **`mutableCopy`**：创建对象的可变副本，不论对象本身是否可变。

### NSString 和 NSMutableString

#### NSString

- `copy`：返回对象本身，因为 `NSString` 是不可变的。
- `mutableCopy`：返回一个新的 `NSMutableString` 对象。

```objc
NSString *originalString = @"Hello, World!";
NSString *stringCopy = [originalString copy]; // 返回原对象本身
NSMutableString *mutableStringCopy = [originalString mutableCopy]; // 返回新的 NSMutableString 对象
```

![](001.png)

#### NSMutableString

- `copy`：返回一个新的 `NSString` 对象，因为 `NSMutableString` 是可变的。
- `mutableCopy`：返回一个新的 `NSMutableString` 对象。

```objc
NSMutableString *originalMutableString = [NSMutableString stringWithString:@"Hello, World!"];
NSString *stringCopy = [originalMutableString copy]; // 返回新的 NSString 对象
NSMutableString *mutableStringCopy = [originalMutableString mutableCopy]; // 返回新的 NSMutableString 对象
```

![](002.png)



### NSArray 和 NSMutableArray

#### NSArray

- `copy`：返回对象本身，因为 `NSArray` 是不可变的。
- `mutableCopy`：返回一个新的 `NSMutableArray` 对象。

```objc
NSArray *originalArray = @[@"One", @"Two", @"Three"];
NSArray *arrayCopy = [originalArray copy]; // 返回原对象本身
NSMutableArray *mutableArrayCopy = [originalArray mutableCopy]; // 返回新的 NSMutableArray 对象
```

![](003.png)



#### NSMutableArray

- `copy`：返回一个新的 `NSArray` 对象，因为 `NSMutableArray` 是可变的。
- `mutableCopy`：返回一个新的 `NSMutableArray` 对象。

```objc
NSMutableArray *originalMutableArray = [NSMutableArray arrayWithArray:@[@"One", @"Two", @"Three"]];
NSArray *arrayCopy = [originalMutableArray copy]; // 返回新的 NSArray 对象
NSMutableArray *mutableArrayCopy = [originalMutableArray mutableCopy]; // 返回新的 NSMutableArray 对象
```

![](004.png)



### 总结

- 对于不可变对象（如 `NSString` 和 `NSArray`），`copy` 方法返回原对象本身，而 `mutableCopy` 方法返回一个新的可变对象。
- 对于可变对象（如 `NSMutableString` 和 `NSMutableArray`），`copy` 方法返回一个新的不可变对象，而 `mutableCopy` 方法返回一个新的可变对象。

这种行为确保了对象的拷贝操作能够正确地维护对象的可变性属性，从而避免不必要的副本创建和内存消耗。














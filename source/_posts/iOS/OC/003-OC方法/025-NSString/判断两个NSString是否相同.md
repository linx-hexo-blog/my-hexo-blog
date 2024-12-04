---
title: 判断两个NSString对象的字面量是否相同
date: {{ date }}
tags:
- iOS
- 面试题
- NSString
---

判断两个NSString的字面量是否相同，为什么要用isEqualToString来判断，而不能用==或isEqual来判断呢？

<!-- more -->

判断两个 NSString 对象的字面量是否相同，使用 isEqualToString: 方法是因为它专门用于比较字符串的字面量，而不是比较对象的地址或其他特征。

使用 == 运算符来判断两个字符串对象的字面量是否相同是不可靠的，因为 == 只比较两个对象的地址是否相同，而不是比较它们的字面量。例如：

```objc
NSString *str1 = @"Hello";
NSString *str2 = [NSString stringWithFormat:@"Hello"];

if (str1 == str2) {
    NSLog(@"The strings are equal"); // 这里不会打印，因为str1和str2是不同的对象
} else {
    NSLog(@"The strings are not equal");
}
```

在上面的例子中，str1 和 str2 的字面量都是 "Hello"，但它们是不同的对象，因此 == 运算符返回 NO。

使用 isEqual: 方法也不是一个好选择，因为它比较两个对象的等价性，而不是专门比较字符串的字面量。例如：

```
NSString *str1 = @"Hello";
NSMutableString *str2 = [NSMutableString stringWithString:@"Hello"];

if ([str1 isEqual:str2]) {
    NSLog(@"The strings are equal"); // 这里会打印，因为str1和str2的字面量相同
} else {
    NSLog(@"The strings are not equal");
}
```
在上面的例子中，str1 和 str2 的字面量都是 "Hello"，因此 isEqual: 方法返回 YES。但是，如果你想比较两个字符串对象的字面量是否相同，而不考虑它们的类别或其他特征，那么使用 isEqualToString: 方法是最好的选择。

isEqualToString: 方法专门用于比较两个字符串对象的字面量，它不考虑对象的地址或类别，只比较它们的字面量。例如：

```
NSString *str1 = @"Hello";
NSString *str2 = [NSString stringWithFormat:@"Hello"];

if ([str1 isEqualToString:str2]) {
    NSLog(@"The strings are equal"); // 这里会打印，因为str1和str2的字面量相同
} else {
    NSLog(@"The strings are not equal");
}
```
因此，在判断两个 NSString 对象的字面量是否相同时，使用 isEqualToString: 方法是最安全和可靠的选择。
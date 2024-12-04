---
title: iOS中copy与mutableCopy
date: {{ date }}
categories: 
- 移动端iOS
tags: [iOS, 面试题, copy]
---

# 参考文档
- 杂七杂八
  - [copy和mutableCopy都是浅拷贝！！！](https://blog.csdn.net/qq_18425655/article/details/51325921)
  - [iOS中的copy，mutableCopy,深拷贝和浅拷贝](https://www.jianshu.com/p/a99f3da35560)
  - [关于NSString的copy和mutableCopy](https://blog.csdn.net/small_smart_jin/article/details/50804607)
  - [iOS中关键字copy与mutableCopy的详解，看我你就都懂了](https://www.jianshu.com/p/700f58eb0b86)
  - [copy和mutableCopy到底是浅拷贝还是深拷贝？](
https://blog.csdn.net/jslsblog/article/details/38563009)
  - [青玉伏案：Objective-C中的深拷贝和浅拷贝](https://www.cnblogs.com/ludashi/p/3894151.html)

- Stackoverflow
  * [Deep Copy and Shallow Copy](https://stackoverflow.com/questions/9912794/deep-copy-and-shallow-copy)
  * [What is the difference between a deep copy and a shallow copy?](https://stackoverflow.com/questions/184710/what-is-the-difference-between-a-deep-copy-and-a-shallow-copy)

- Documents
  * [apple documentation Copy ](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Collections/Articles/Copying.html#//apple_ref/doc/uid/TP40010162-SW3)
  * [维基百科 - Object copying](https://en.wikipedia.org/wiki/Object_copying)

# 目录
* 一、copy、mutableCopy
* 二、系统的非容器类对象：这里指的是NSString、NSNumber等对象。
* 三、系统的容器类对象：指NSArray，NSSet，NSDictionary等。
* 四、另一个角度来看
  * 4.1、浅拷贝
  * 4.2、单层深copy
  * 4.3、双层深拷贝
  * 4.4、完全深拷贝
  * 4.5、自定义类对象之间的深浅拷贝问题
* 五、@property中的copy关键字
* 六、copy和block


# 一、copy、mutableCopy

> * ##### copy：不可变拷贝,遵循NSCopying协议，需要对应实现copyWithZone方法；
> * ##### mutableCopy：可变拷贝，遵循NSMutableCopying协议，需要对应实现mutableCopyWithZone:方法；

![](005.webp)



# 二、系统的非容器类对象：这里指的是NSString、NSNumber等对象。

```
 // const是常量字符串,存在常量区 
 // constStr指针存在栈区, 指针指向常量区 
NSString * constStr = @"const";
NSString * constStrCopy = [constStr copy];
NSMutableString * constStrMutableCopy = [constStr mutableCopy];
NSLog(@"constStr = %p = %@",constStr,constStr);
NSLog(@"constStrCopy = %p = %@",constStrCopy,constStrCopy);
NSLog(@"constStrMutableCopy = %p = %@",constStrMutableCopy,constStrMutableCopy);

// originStr在栈中,指向堆区的地址 
NSString * originStr = [NSString stringWithFormat:@"origin"];
NSString * originStrCopy = [originStr copy];
NSMutableString * originStrMutableCopy = [originStr mutableCopy];
NSLog(@"originStr = %p = %@",originStr,originStr);
NSLog(@"originStrCopy = %p = %@",originStrCopy,originStrCopy);
NSLog(@"originStrMutableCopy = %p = %@",originStrMutableCopy,originStrMutableCopy);
    
NSMutableString *mutableOriginStr = [NSMutableString stringWithFormat:@"mutableOrigin"];
NSMutableString *mutableOriginStrCopy = [mutableOriginStr copy];
NSMutableString *mutableOriginStrMutableCopy = [mutableOriginStr mutableCopy];
NSLog(@"mutableOriginStr = %p = %@",mutableOriginStr,mutableOriginStr);
NSLog(@"mutableOriginStrCopy = %p = %@",mutableOriginStrCopy,mutableOriginStrCopy);
NSLog(@"mutableOriginStrMutableCopy = %p = %@",mutableOriginStrMutableCopy,mutableOriginStrMutableCopy);


// 返回值测试对象是否为mutable
[constStrMutableCopy appendString:@"const"];
[originStrMutableCopy appendString:@"origin"];
#pragma warnning - ERROR
[mutableOriginStrCopy appendString:@"mm"];   // ERROR
```
输出
```
constStr = 0x109a32558
constStrCopy = 0x109a32558
constStrMutableCopy = 0x60000307ad00

originStr = 0xc117d077374719f4
originStrCopy = 0xc117d077374719f4
originStrMutableCopy = 0x60000307ac40

mutableOriginStr = 0x60000307ac70
mutableOriginStrCopy = 0x600003e7d960
mutableOriginStrMutableCopy = 0x60000307adc0
```

![总结图](006.png)

> ###### 总结：对于系统的非容器类对象，我们可以认为，如果对不可变对象复制，copy是指针复制（浅拷贝）和mutableCopy就是对象复制（深拷贝）。如果是对可变对象复制，都是深拷贝，但是copy返回的对象是不可变的。
> ######  copy返回的对象是不可变的，mutableCopy是可变的。

**NSString内存分配结论：**
[iOS的关于堆区和栈区](https://www.aliyun.com/jiaocheng/359361.html)
```
@"" 和 initWithString：方法生成的字符串分配在常量区，系统自动管理内存；

initWithFormat：和 stringWithFormat: 方法生成的字符串分配在堆区，autorelease；
```

# 三、系统的容器类对象：指NSArray，NSSet，NSDictionary等。

[copy和mutableCopy都是浅拷贝！！！](https://blog.csdn.net/qq_18425655/article/details/51325921)
[iOS深浅拷贝（纠错）](https://www.jianshu.com/p/ad1fb29b6070)


![浅拷贝与深拷贝](007.png)


> ###### 观点一： 所有系统容器类的copy或mutableCopy方法，都是浅拷贝！！！

**验证一：NSArray进行copy与mutableCopy，并改变NSArray内元素值，查看拷贝对象内部值的变化。**
```
    NSArray * arr = [NSArray arrayWithObjects:
                     [NSMutableString stringWithString:@"one"],
                     [NSMutableString stringWithString:@"two"],
                     [NSMutableString stringWithString:@"three"],
                     [NSMutableString stringWithString:@"four"],nil];
    NSArray * arrcopy = [arr copy];
    NSMutableArray * arrmutablecopy = [arr mutableCopy];
    NSLog(@"arr = %p = %p",arr,arr[0]);
    NSLog(@"arrcopy = %p = %p",arrcopy,arrcopy[0]);
    NSLog(@"arrmutablecopy = %p = %p",arrmutablecopy,arrmutablecopy[0]);

    NSMutableString * mStr;
    mStr = arr[0];
    [mStr appendString:@"--array"];

    NSLog(@"改变内部元素后 arr：%@ = %p",arr,arr[0]);
    NSLog(@"改变内部元素后 arrcopy：%@ = %p",arrcopy,arrcopy[0]);
    NSLog(@"改变内部元素后 arrmutablecopy：%@ = %p",arrmutablecopy,arrmutablecopy[0]);
```

输出
```
arr = 0x604000446390 = 0x604000445d90
arrcopy = 0x604000446390 = 0x604000445d90
arrmutablecopy = 0x604000445520 = 0x604000445d90
改变内部元素后 arr：(
    "one--array",
    two,
    three,
    four
) = 0x604000445d90
改变内部元素后 arrcopy：(
    "one--array",
    two,
    three,
    four
) = 0x604000445d90
改变内部元素后 arrmutablecopy：(
    "one--array",
    two,
    three,
    four
) = 0x604000445d90
```

**验证二：NSMutableArray进行copy与mutableCopy，并改变NSMutableArray内元素值，查看拷贝对象内部值的变化。**

```
    NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:
                                  [NSMutableString stringWithString:@"abc"],
                                  [NSMutableString stringWithString:@"def"],
                                  [NSMutableString stringWithString:@"ghi"],
                                  [NSMutableString stringWithString:@"jkl"], nil];
    NSArray * mutableArrcopy = [mutableArr copy];
    NSMutableArray * mutableArrmutablecopy = [mutableArr mutableCopy];
    NSLog(@"mutableArr = %p = %p",mutableArr,mutableArr[0]);
    NSLog(@"mutableArrcopy = %p = %p",mutableArrcopy,mutableArrcopy[0]);
    NSLog(@"mutableArrmutablecopy = %p = %p",mutableArrmutablecopy,mutableArrmutablecopy[0]);
    
    NSMutableString * mStr1;
    mStr1 = mutableArr[0];
    [mStr1 appendString:@"--mutablearray"];
    
    [mutableArrmutablecopy addObject:@"FFF"];
    
    NSLog(@"改变内部元素后 mutableArr：%@ = %p",mutableArr,mutableArr[0]);
    NSLog(@"改变内部元素后 mutableArrcopy：%@ = %p",mutableArrcopy,mutableArrcopy[0]);
    NSLog(@"改变内部元素后 mutableArrmutablecopy：%@ = %p",mutableArrmutablecopy,mutableArrmutablecopy[0]);
```

输出
```
mutableArr = 0x604000452b10 = 0x604000452a80
mutableArrcopy = 0x604000452b70 = 0x604000452a80
mutableArrmutablecopy = 0x60400025fe90 = 0x604000452a80
改变内部元素后 mutableArr：(
    "abc--mutablearray",
    def,
    ghi,
    jkl
) = 0x604000452a80
改变内部元素后 mutableArrcopy：(
    "abc--mutablearray",
    def,
    ghi,
    jkl
) = 0x604000452a80
改变内部元素后 mutableArrmutablecopy：(
    "abc--mutablearray",
    def,
    ghi,
    jkl,
    FFF
) = 0x604000452a80
```

![总结图](006.png)

> ###### 总结：copy操作返回的必然是一个不可变对象，无论源对象是可变对象还是不可变对象。如果源对象是一个不可变对象，那么它们（源对象和新生成的对象）指向同一个对象，如果源对象是可变对象，它们指向不同对象。
> ###### mutableCopy返回的必然是一个可变对象，无论源对象是可变对象还是不可变对象，它们（源对象和新生成的对象）仍指向不同地址，是两个对象。


> ###### 特别注意的是：对于集合类的可变对象来说，深拷贝并非严格意义上的深复制，只能算是单层深复制，即虽然新开辟了内存地址，但是存放在内存上的值（也就是数组里的元素仍然之原数组元素值，并没有另外复制一份），这就叫做单层深复制。



# 四、另一个角度来看

## 4.1、浅拷贝

[iOS 图文并茂的带你了解深拷贝与浅拷贝](https://www.cnblogs.com/beckwang0912/p/7212075.html)
[Objective-C copy，看我就够了](https://www.jianshu.com/p/ebbac2fec4c6)

```
NSArray *arr = [NSArray arrayWithObjects:@"1", nil];
NSArray *copyArr = [arr copy];
NSLog(@"%p", arr);
NSLog(@"%p", copyArr);
```
输出：浅拷贝
```
2018-10-24 10:00:17.256591+0800 TodayNews[2229:70407] 0x60000043d3c0
2018-10-24 10:00:17.256705+0800 TodayNews[2229:70407] 0x60000043d3c0
```

## 4.2、单层深copy

**这里的单层指的是完成了NSArray对象的深copy，而未对其容器内对象进行处理。**
```
NSArray *arr = [NSArray arrayWithObjects:@"1", nil];
NSArray *copyArr = [arr mutableCopy];
    
NSLog(@"%p", arr);
NSLog(@"%p", copyArr);
    
// 打印arr、copyArr内部元素进行对比
NSLog(@"%p", arr[0]);
NSLog(@"%p", copyArr[0]);
```
输出：
```
2018-10-24 10:06:10.985032+0800 TodayNews[2330:73697] 0x60000043a200
2018-10-24 10:06:10.985224+0800 TodayNews[2330:73697] 0x600000642a60
2018-10-24 10:06:10.985347+0800 TodayNews[2330:73697] 0x102bf00d8
2018-10-24 10:06:10.985438+0800 TodayNews[2330:73697] 0x102bf00d8
```

## 4.3、双层深拷贝
```
    // 随意创建一个NSMutableString对象
    NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
    // 随意创建一个包涵NSMutableString的NSMutableArray对象
    NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
    // 将mutableString和mutableArr放入一个新的NSArray中
    NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
    // 通过官方文档提供的方式创建copy
    NSArray *testArrCopy = [[NSArray alloc] initWithArray:testArr copyItems:YES];
    
    // testArr和testArrCopy指针对比
    NSLog(@"%p", testArr);
    NSLog(@"%p", testArrCopy);
    
    // testArr和testArrCopy中元素指针对比
    // mutableString对比
    NSLog(@"%p", testArr[0]);
    NSLog(@"%p", testArrCopy[0]);
    // mutableArr对比
    NSLog(@"%p", testArr[1]);
    NSLog(@"%p", testArrCopy[1]);
    
    // mutableArr中的元素对比，即mutalbeString1对比
    NSLog(@"%p", testArr[1][0]);
    NSLog(@"%p", testArrCopy[1][0]);
```
输出

```
2018-10-24 10:10:20.994041+0800 TodayNews[2442:76854] 0x600000426500
2018-10-24 10:10:20.994165+0800 TodayNews[2442:76854] 0x6000004264c0
2018-10-24 10:10:20.994280+0800 TodayNews[2442:76854] 0x600000652870
2018-10-24 10:10:20.994421+0800 TodayNews[2442:76854] 0xa000000000000311
2018-10-24 10:10:20.994512+0800 TodayNews[2442:76854] 0x600000652960
2018-10-24 10:10:20.994599+0800 TodayNews[2442:76854] 0x600000005ef0
2018-10-24 10:10:20.994701+0800 TodayNews[2442:76854] 0x6000006528a0
2018-10-24 10:10:20.994993+0800 TodayNews[2442:76854] 0x6000006528a0
```

## 4.4、完全深拷贝

方式一：**如果想完美的解决NSArray嵌套NSArray这种情形，可以使用归档、解档的方式。**
```
// 随意创建一个NSMutableString对象
NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
// 随意创建一个包涵NSMutableString的NSMutableArray对象
NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
// 将mutableString和mutableArr放入一个新的NSArray中
NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
// 通过归档、解档方式创建copy
NSArray *testArrCopy = [NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:testArr]];;
    
// testArr和testArrCopy指针对比
NSLog(@"%p", testArr);
NSLog(@"%p", testArrCopy);
    
// testArr和testArrCopy中元素指针对比
// mutableString对比
NSLog(@"%p", testArr[0]);
NSLog(@"%p", testArrCopy[0]);
// mutableArr对比
NSLog(@"%p", testArr[1]);
NSLog(@"%p", testArrCopy[1]);
    
// mutableArr中的元素对比，即mutalbeString1对比
NSLog(@"%p", testArr[1][0]);
NSLog(@"%p", testArrCopy[1][0]);
```
输出

```
2018-10-24 10:15:11.448311+0800 TodayNews[2549:80583] 0x600000430640
2018-10-24 10:15:11.448435+0800 TodayNews[2549:80583] 0x6000004309e0
2018-10-24 10:15:11.448528+0800 TodayNews[2549:80583] 0x60000045e2a0
2018-10-24 10:15:11.448684+0800 TodayNews[2549:80583] 0x60000045e3c0
2018-10-24 10:15:11.448773+0800 TodayNews[2549:80583] 0x60000045d0d0
2018-10-24 10:15:11.448925+0800 TodayNews[2549:80583] 0x60000045e450
2018-10-24 10:15:11.449012+0800 TodayNews[2549:80583] 0x60000045e1b0
2018-10-24 10:15:11.449161+0800 TodayNews[2549:80583] 0x60000045e7e0
```

**方式二：```- (instancetype)initWithArray:(NSArray<ObjectType> *)array copyItems:(BOOL)flag```;**

```
NSMutableArray *marry1 = [[NSMutableArray alloc] init];
    
NSMutableString *mstr1 = [[NSMutableString alloc]initWithString:@"value1"];
NSMutableString *mstr2 = [[NSMutableString alloc]initWithString:@"value2"];
    
[marry1 addObject:mstr1];
[marry1 addObject:mstr2];
    
NSArray *marray2 = [[NSArray alloc] initWithArray:marry1 copyItems:YES];
    
NSLog(@"marry1:%p - %@ \r\n",marry1,marry1);
NSLog(@"marry2:%p - %@ \r\n",marray2,marray2);
NSLog(@"数组元素地址:value1:%p - value2:%p \r\n",marry1[0],marry1[1]);
NSLog(@"数组元素地址:value1:%p - value2:%p \r\n",marray2[0],marray2[1]);
```

## 4.5、自定义类对象之间的深浅拷贝问题

在Objective-C中并不是所有的类都支持拷贝；只有遵循NSCopying协议的类，才支持copy拷贝，只有遵循NSMutableCopying协议的类，才支持mutableCopy拷贝。如果没有遵循拷贝协议，拷贝时会出错。

如果我们想再我们自定义的类中支持copy和mutableCopy那么我们就需要使我们定义的类遵循NSCopying和NSMutableCopying协议，代码如下：

```
@interface Study_CustomObject_copy_mutableCopy : NSObject <NSCopying, NSMutableCopying>  // 协议
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *age;
@end

@implementation Study_CustomObject_copy_mutableCopy
- (id)copyWithZone:(NSZone *)zone
{
    Study_CustomObject_copy_mutableCopy *customobject = [[Study_CustomObject_copy_mutableCopy allocWithZone:zone] init];
    customobject.age = self.age;
    customobject.name = self.name;
    return customobject;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    Study_CustomObject_copy_mutableCopy *customobject = [[Study_CustomObject_copy_mutableCopy allocWithZone:zone] init];
    customobject.age = self.age;
    customobject.name = self.name;
    return customobject;
}
@end
```


**调用 、 输出**

```
// 调用
{
    Study_CustomObject_copy_mutableCopy *object = [[Study_CustomObject_copy_mutableCopy alloc]init];
    object.age = @"99";
    object.name = @"lionsom";
    
    Study_CustomObject_copy_mutableCopy *objectCopy = [object copy];
    Study_CustomObject_copy_mutableCopy *objectMutableCopy = [object mutableCopy];
    
    NSLog(@"object === %p , name === %p , age === %p",object, object.name, object.age);
    NSLog(@"objectCopy === %p , name === %p , age === %p",objectCopy, objectCopy.name, objectCopy.age);
    NSLog(@"objectMutableCopy === %p , name === %p , age === %p",objectMutableCopy, objectMutableCopy.name, objectMutableCopy.age);
}

// 输出
object === 0x60400023d7a0 , name === 0x100744ed8 , age === 0x100744eb8
objectCopy === 0x60400023bd80 , name === 0x100744ed8 , age === 0x100744eb8
objectMutableCopy === 0x60400023d180 , name === 0x100744ed8 , age === 0x100744eb8
```


# 五、@property中的copy关键字
[iOS内存管理（6）--NSArray与NSMutableArray用copy修饰还是strong](https://blog.csdn.net/winzlee/article/details/51752354)
[OC的深拷贝与浅拷贝--NSArray与NSMutableArray应该使用copy还是strong？](https://blog.csdn.net/G_eorge/article/details/78219957?locationNum=9&fps=1)

* ##### NSString
  *  strong 关键词：两个string指向相同的内存地址，修改一个，另一个也会改变；
  * (**推荐**)copy 关键词：两个string指向不同的内存地址，互不影响；

* ##### NSMutableString
   * (**推荐**)strong 关键词：两个string指向相同的内存地址，修改一个，另一个也会改变；
  * (**崩溃**)copy 关键词：copy之后，就把变量string变成了不可变的NSString类型，对不可变的NSString使用了NSMutableString的方法appendString。

* ##### NSArray
  * strong 关键词：两个string指向相同的内存地址，修改一个，另一个也会改变；
  * (**推荐**)copy 关键词：此时内存地址都是不同的，修改一个，互不影响；

* ##### NSMutableArray
  * (**推荐**)strong 关键词：两个string指向相同的内存地址，修改一个，另一个也会改变；
  * (**崩溃**)copy 关键词：copy之后，就把变量array变成了不可变的NSArray类型，对不可变的NSArray使用了NSMutableArray的方法addObject。


> 当修饰可变类型的属性时，如NSMutableArray、NSMutableDictionary、NSMutableString，用strong。
>
> 当修饰不可变类型的属性时，如NSArray、NSDictionary、NSString，用copy。


# 六、copy和block

[block使用copy原理](https://blog.csdn.net/leonliu070602/article/details/52981884)

简单来说，block就像一个函数指针，指向我们要使用的函数。

就和函数调用一样的，不管你在哪里写了这个block，只要你把它放在了内存中（通过调用存在这个block的方法或者是函数），不管放在栈中还是在堆中，还是在静态区。只要他没有被销毁，你都可以通过你声明的block调用他。

说到在类中声明一个block为什么要用copy修饰的话，那就要先说block的三种类型。



1._NSConcreteGlobalBlock,全局的静态block，不会访问外部的变量。就是说如果你的block没有调用其他的外部变量，那你的block类型就是这种。例如：你仅仅在你的block里面写一个NSLog("hello world");

2._NSConcreteStackBlock 保存在栈中的 block，当函数返回时会被销毁。这个block就是你声明的时候不用c opy修饰，并且你的block访问了外部变量。

3._NSConcreteMallocBlock 保存在堆中的 block，当引用计数为 0 时会被销毁。好了，这个就是今天的主角 ，用copy修饰的block。



我们知道，函数的声明周期是随着函数调用的结束就终止了。我们的block是写在函数中的。

如果是全局静态block的话，他直到程序结束的时候，才会被被释放。但是我们实际操作中基本上不会使用到不访问外部变量的block。【但是在测试三种区别的时候，因为没有很好的理解这种block，（用没有copy修饰和没有访问外部变量的block）试了好多次，以为是放在静态区里面的block没有随函数结束被释放。这是个小坑】

如果是保存在栈中的block，他会随着函数调用结束被销毁。从而导致我们在执行一个包含block的函数之后，就无法再访问这个block。因为（函数结束，函数栈就销毁了，存在函数里面的block也就没有了），我们再使用block时，就会产生空指针异常。

如果是堆中的block，也就是copy修饰的block。他的生命 周期就是随着对象的销毁而结束的。只要对象不销毁，我们就可以调用的到在堆中的block。



这就是为什么我们要用copy来修饰block。因为不用copy修饰的访问外部变量的block，只在他所在的函数被调用的那一瞬间可以使用。之后就消失了。







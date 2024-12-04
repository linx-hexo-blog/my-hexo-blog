---
title: iOS同步机制
date: {{ date }}
tags: [iOS, 面试题, 同步]
thumbnail: 'https://raw.githubusercontent.com/lionsom/imagesRepo/hexo/hexo-common-img/202407291538172.jpeg'
---

<!-- # iOS同步机制 -->

iOS 提供了多种同步机制来确保多线程环境中的数据安全和操作一致性。以下是一些常用的同步机制：

 <!-- more -->
 
### 1. @synchronized
`synchronized` 是 Objective-C 中的一种便捷方式，用于确保代码块的执行是互斥的。它会创建一个隐式的锁对象，确保同一时间只有一个线程可以执行代码块内的代码。

```objective-c
@synchronized (self) {
    // 需要同步执行的代码
}
```

**优点**：简单易用，适合小范围的临界区保护。

**缺点**：性能开销较大，不适合高频率调用。

### 2. NSLock
`NSLock` 是一种基础的锁机制，提供了互斥锁的功能。使用时，需要显式地调用 `lock` 和 `unlock` 方法。

```objective-c
NSLock *lock = [[NSLock alloc] init];
[lock lock];
// 需要同步执行的代码
[lock unlock];
```

**优点**：相对于 `@synchronized`，性能稍好一些，使用灵活。

**缺点**：需要显式调用锁和解锁，容易导致死锁。

### 3. NSRecursiveLock
`NSRecursiveLock` 是一种递归锁，允许同一线程多次获得锁而不会引发死锁。

```objective-c
NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
[recursiveLock lock];
// 需要同步执行的代码
[recursiveLock unlock];
```

**优点**：适合递归调用的场景。

**缺点**：相对于普通锁，性能略低。

### 4. NSCondition
`NSCondition` 提供了一种更复杂的锁机制，支持线程等待和唤醒的功能。

```objective-c
NSCondition *condition = [[NSCondition alloc] init];
[condition lock];
// 需要同步执行的代码
[condition wait]; // 等待某个条件
[condition signal]; // 唤醒等待的线程
[condition unlock];
```

**优点**：适合需要线程等待和唤醒的复杂场景。

**缺点**：使用复杂，性能较低。

### 5. NSConditionLock
`NSConditionLock` 是 `NSCondition` 的变种，增加了条件变量的支持，可以更方便地实现复杂的同步场景。

```objective-c
NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:0];
[conditionLock lockWhenCondition:1];
// 需要同步执行的代码
[conditionLock unlockWithCondition:2];
```

**优点**：适合有条件变量的复杂场景。

**缺点**：使用复杂，性能较低。

### 6. GCD (Grand Central Dispatch)
GCD 提供了非常强大的多线程支持，特别是同步机制。常用的同步方法包括 `dispatch_sync` 和同步队列。

#### 串行队列
创建一个串行队列，确保任务按顺序执行。

```objective-c
dispatch_queue_t serialQueue = dispatch_queue_create("com.example.serialQueue", DISPATCH_QUEUE_SERIAL);
dispatch_sync(serialQueue, ^{
    // 需要同步执行的代码
});
```

#### dispatch_barrier
在并行队列中使用 `dispatch_barrier_async` 或 `dispatch_barrier_sync` 确保读写操作的互斥性。

```objective-c
dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
dispatch_barrier_async(concurrentQueue, ^{
    // 需要同步执行的写操作
});
```

**优点**：性能高，使用灵活，适合各种场景。

**缺点**：API 较多，学习曲线稍高。

### 7. Atomic Properties
在 Objective-C 中，可以使用 `atomic` 修饰符来声明线程安全的属性。尽管不适合所有情况，但在简单的读写操作中可以提供一定程度的线程安全保障。

```objective-c
@property (atomic, strong) NSString *atomicString;
```

**优点**：简单易用，适合简单的读写操作。

**缺点**：性能较低，无法解决复杂的同步问题。

### 总结
iOS 提供了多种同步机制，从简单易用的 `@synchronized` 到强大灵活的 GCD，不同的机制适用于不同的场景。在选择同步机制时，需要根据具体需求和性能要求进行权衡。
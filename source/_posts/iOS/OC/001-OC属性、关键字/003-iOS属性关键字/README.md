---
title: iOS 属性关键字
date: {{ date }}
tags: [iOS, 面试题, 属性关键字]
---

<!-- # iOS 属性关键字 -->

在iOS开发中，属性关键字用于修饰属性的行为和特性。理解和正确使用这些关键字可以帮助开发者更好地管理对象的内存和线程安全性。以下是常用的属性关键字及其解释：
 
 <!-- more -->

### 内存管理关键字
- **strong**：表示对对象的强引用，属性会持有对象，引用计数增加。
  ```objective-c
  @property (nonatomic, strong) NSString *name;
  ```
  
- **weak**：表示对对象的弱引用，属性不会持有对象，引用计数不增加。如果对象被释放，weak引用会自动设置为nil，避免野指针。
  ```objective-c
  @property (nonatomic, weak) id<Delegate> delegate;
  ```
  
- **assign**：直接赋值，不更改引用计数。通常用于基本数据类型或不需要持有的对象。
  ```objective-c
  @property (nonatomic, assign) NSInteger age;
  ```
  
- **copy**：表示对对象进行拷贝，属性会持有拷贝后的对象。适用于NSString等类，为了防止属性被外部修改。
  ```objective-c
  @property (nonatomic, copy) NSString *title;
  ```

- **unsafe_unretained**：与weak类似，但对象被释放后不会自动设置为nil，容易导致野指针。适用于不支持弱引用的对象（在ARC之前常用）。
  ```objective-c
  @property (nonatomic, unsafe_unretained) id delegate;
  ```

### 原子性关键字
- **atomic**：默认行为，确保属性的读写操作是线程安全的。性能较低，因为每次访问属性时都需要加锁。
  ```objective-c
  @property (atomic, strong) NSString *name;
  ```

- **nonatomic**：不保证线程安全，性能较高，适用于大多数场景。
  ```objective-c
  @property (nonatomic, strong) NSString *name;
  ```

### 属性的读写权限关键字
- **readonly**：只生成getter方法，不生成setter方法，属性只能读不能写。
  ```objective-c
  @property (nonatomic, readonly) NSString *identifier;
  ```

- **readwrite**：生成getter和setter方法，属性可读可写。默认行为。
  ```objective-c
  @property (nonatomic, readwrite) NSString *name;
  ```

### 自定义方法名关键字
- **getter**：自定义getter方法名。
  ```objective-c
  @property (nonatomic, getter=isEnabled) BOOL enabled;
  ```

- **setter**：自定义setter方法名。
  ```objective-c
  @property (nonatomic, setter=setEnabled:) BOOL enabled;
  ```

### 内存管理策略（在MRC中使用）
- **retain**：表示对对象的强引用，属性会持有对象，引用计数增加。ARC环境下用strong代替。
  ```objective-c
  @property (nonatomic, retain) NSString *name;
  ```

- **assign**：直接赋值，不更改引用计数。ARC环境下用weak或assign代替。
  ```objective-c
  @property (nonatomic, assign) NSInteger age;
  ```

- **copy**：表示对对象进行拷贝，属性会持有拷贝后的对象。ARC环境下与strong结合使用。
  ```objective-c
  @property (nonatomic, copy) NSString *title;
  ```

### 特殊关键字
- **nonnull**：表示属性不能为空。
  ```objective-c
  @property (nonatomic, strong, nonnull) NSString *name;
  ```

- **nullable**：表示属性可以为空。
  ```objective-c
  @property (nonatomic, strong, nullable) NSString *name;
  ```

- **null_resettable**：属性可以为空，但在访问时会自动初始化。
  ```objective-c
  @property (nonatomic, strong, null_resettable) UIView *view;
  ```

### 总结
理解和正确使用属性关键字，可以有效管理内存、提高性能和确保线程安全。根据不同的场景选择合适的关键字，可以让代码更加健壮和高效。
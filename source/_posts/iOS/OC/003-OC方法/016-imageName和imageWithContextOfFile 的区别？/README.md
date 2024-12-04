---
title: imageName 和 imageWithContextOfFile 的区别？哪个性能高？
date: {{ date }}
tags:
- iOS
- 面试题
- imageName
---

> imageNamed性能高，因为他缓存到内存中了！

1. 用imageNamed的方式加载时，图片使用完毕后缓存到内存中，内存消耗多，加载速度快。即使生成的对象被 autoReleasePool释放了，这份缓存也不释放，如果图像比较大，或者图像比较多，用这种方式会消耗很大的内存。imageNamed采用了缓存机制，如果缓存中已加载了图片，直接从缓存读就行了，每次就不用再去读文件了，效率会更高 
2. imageWithContextOfFile加载，图片是不会缓存的，加载速度慢。
3. 大量使用imageNamed方式会在不需要缓存的地方额外增加开销CPU的时间。当应用程序需要加载一张比较大的图片并且使用一次性，那么其实是没有必要去缓存这个图片的，用imageWithContentsOfFile是最为经济的方式,这样不会因为UIImage元素较多情况下，CPU会被逐个分散在不必要缓存上浪费过多时间.

**结论**

* 如果图片较小,并且频繁使用的图片,使用imageName:来加载图片(按钮图片/主页图片/占位图)
* 如果图片较大,并且使用次数较少,使用 imageWithContentOfFile:来加载(相册/版本新特性)


# GPT

在iOS开发中，`imageNamed:` 和 `imageWithContentsOfFile:` 是两个常用的加载图片的方法。它们有不同的用途和性能特点。

### `imageNamed:`

**用法：**

```objective-c
UIImage *image = [UIImage imageNamed:@"example.png"];
```

**特点：**

- **缓存机制**：`imageNamed:` 方法会缓存已经加载的图片。当再次请求相同名称的图片时，会直接从缓存中获取，而不是重新加载。这可以提高性能，尤其是在多次使用相同图片的情况下。
- **适用于资源包中的图片**：通常用于加载应用程序包中的图片资源。
- **不需要提供文件路径**：只需要提供图片名称，系统会自动在资源包中查找。

**适用场景：**

- 适合加载应用程序包中的小图片。
- 适合频繁使用的图片，因为缓存机制可以提高性能。

### `imageWithContentsOfFile:`

**用法：**

```objective-c
NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"png"];
UIImage *image = [UIImage imageWithContentsOfFile:filePath];
```

**特点：**

- **无缓存机制**：`imageWithContentsOfFile:` 每次调用都会从磁盘加载图片，不会缓存。这意味着在频繁使用同一图片时，性能可能会受到影响。
- **需要提供完整路径**：需要提供图片的完整文件路径。
- **适用于沙盒中的图片**：可以加载沙盒中的图片资源。

**适用场景：**

- 适合加载不经常使用的图片。
- 适合加载动态生成或下载到沙盒中的图片。

### 性能比较

- **内存占用**：由于`imageNamed:`会缓存图片，如果加载大量图片，可能会增加内存占用。而`imageWithContentsOfFile:`每次都从磁盘读取图片，内存占用较低，但会增加磁盘I/O。
- **加载速度**：对于多次使用同一图片的情况，`imageNamed:`的性能更高，因为缓存机制避免了重复的磁盘I/O。对于一次性加载的图片，`imageWithContentsOfFile:`可以避免不必要的内存缓存。
- **适用场景**：在需要频繁使用相同图片的场景下，`imageNamed:`更具优势。在只需要偶尔加载或一次性使用图片的场景下，`imageWithContentsOfFile:`更适合。

### 示例代码

**`imageNamed:` 示例**

```objective-c
UIImage *image = [UIImage imageNamed:@"example.png"];
```

**`imageWithContentsOfFile:` 示例**

```objective-c
NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"png"];
UIImage *image = [UIImage imageWithContentsOfFile:filePath];
```

### 总结

- **`imageNamed:`**：适合频繁使用的图片，具有缓存机制，加载速度快，内存占用相对较高。
- **`imageWithContentsOfFile:`**：适合偶尔使用或动态加载的图片，无缓存机制，加载速度稍慢，但内存占用较低。

选择哪个方法取决于具体的使用场景和性能需求。对于频繁使用的图片资源，建议使用`imageNamed:`；对于一次性加载或动态生成的图片资源，建议使用`imageWithContentsOfFile:`。
---
title: loadView介绍
date: {{ date }}
tags:
- iOS
- 面试题
- loadView
---

在iOS开发中，`loadView`是`UIViewController`类的一个生命周期方法，它负责加载或创建视图控制器的根视图。当视图控制器的视图属性被访问，但视图尚未加载时，系统会调用`loadView`方法。

<!-- more -->

### `loadView`的调用时机

`loadView`方法在以下情况下会被调用：

1. **访问视图控制器的`view`属性**：当视图控制器的`view`属性首次被访问时，如果视图还没有被加载，系统会调用`loadView`方法来加载或创建视图。

2. **系统需要加载视图**：在视图控制器的生命周期过程中，如果视图尚未加载但需要显示，系统会调用`loadView`方法。

### `loadView`的作用

`loadView`方法的主要作用是加载或创建视图控制器的根视图。默认情况下，`UIViewController`会从一个名为与视图控制器相同名称的`xib`文件或故事板中加载视图。如果没有关联的`xib`文件或故事板，系统会创建一个空的`UIView`实例作为根视图。

### 自定义`loadView`

通常不需要重写`loadView`方法，而是通过故事板或`xib`文件来配置视图控制器的视图。但是，如果你需要完全以编程方式创建视图，可以重写`loadView`方法。

#### 示例代码

以下是一个自定义`loadView`方法的示例：

```swift
import UIKit

class CustomViewController: UIViewController {
    
    override func loadView() {
        // 创建一个自定义的根视图
        let customView = UIView()
        customView.backgroundColor = .white
        
        // 添加子视图
        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(label)
        
        // 设置约束
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
        ])
        
        // 将自定义视图设置为视图控制器的根视图
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 其他初始化代码
    }
}
```

### `loadView`与其他生命周期方法的关系

- `loadView`：负责创建视图控制器的根视图。只有当视图控制器的视图尚未加载且`view`属性被访问时才会被调用。
- `viewDidLoad`：在视图控制器的视图已经加载完成后被调用。通常在这里进行视图的额外设置或初始化工作。
- `viewWillAppear`：在视图即将显示在屏幕上时被调用。
- `viewDidAppear`：在视图已经显示在屏幕上时被调用。
- `viewWillDisappear`：在视图即将从屏幕上消失时被调用。
- `viewDidDisappear`：在视图已经从屏幕上消失时被调用。

### 注意事项

- **不要直接调用**`loadView`：`loadView`方法由系统调用，不应在代码中直接调用。如果需要强制加载视图，可以通过访问`view`属性来触发。
- **不要调用**`super.loadView()`：如果重写`loadView`方法，不要调用`super.loadView()`，因为默认实现会从`xib`文件或故事板加载视图。如果你是完全以编程方式创建视图，这一步是没有必要的。

### 总结

`loadView`方法在视图控制器的视图属性首次被访问时由系统调用，用于加载或创建根视图。通常通过故事板或`xib`文件配置视图，但在某些情况下可以通过重写`loadView`方法以编程方式创建自定义视图。合理使用`loadView`方法和其他生命周期方法，可以确保视图控制器的视图正确初始化和显示。
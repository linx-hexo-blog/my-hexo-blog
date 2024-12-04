---
title: View的layout的方法
date: {{ date }}
tags:
- iOS
- 面试题
- View
- layout
---

[iOS 谈谈layoutSubviews何用](https://www.jianshu.com/p/2ef48c2f0c97)

<!-- more-->

下面列出View的layout的方法:
```
layoutSubviews
layoutIfNeeded
setNeedsLayout
setNeedsDisplay
drawRect
sizeThatFits
sizeToFit
```

# layoutSubviews

`layoutSubviews` 是 `UIView` 的一个方法，用于在视图的子视图布局发生变化时进行重新布局。它的调用时机有以下几种情况：

### 1. 初始布局
当视图第一次显示时，系统会自动调用 `layoutSubviews` 方法以布局视图及其子视图。

### 2. 布局发生变化
当视图的 `frame` 或 `bounds` 改变时，系统会调用 `layoutSubviews` 方法。例如，通过设置视图的 `frame` 或 `bounds` 来改变视图的大小或位置时。

### 3. 子视图添加或移除
当向视图中添加或移除子视图时，`layoutSubviews` 会被调用。例如，使用 `addSubview:` 或 `removeFromSuperview` 方法时。

### 4. 设置需要布局更新
当调用 `setNeedsLayout` 方法时，系统会标记视图需要重新布局，并在下一个布局周期调用 `layoutSubviews` 方法。

### 5. 设置需要显示更新
当调用 `setNeedsDisplay` 方法时，系统也会调用 `layoutSubviews` 方法，因为需要重新绘制视图。

### 6. 设备旋转
当设备旋转导致屏幕尺寸变化时，系统会调用 `layoutSubviews` 方法以适应新的屏幕尺寸。

### 例子

```swift
class CustomView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 在此处调整子视图的布局
        subview.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
    }
}
```

在这个示例中，每当 `CustomView` 的 `frame` 或 `bounds` 发生变化时，系统会调用 `layoutSubviews` 方法，在该方法中可以调整 `subview` 的 `frame` 以适应新的尺寸。

### 总结
`layoutSubviews` 方法在视图的布局或子视图的布局需要更新时被调用。理解它的调用时机有助于在自定义视图时正确处理布局更新。



# layoutIfNeeded

`layoutIfNeeded` 是 `UIView` 的一个方法，用于立即布局视图及其子视图。通常情况下，视图的布局会在下一个运行循环中异步执行，但是如果你希望立即执行布局而不等待下一个运行循环，可以调用 `layoutIfNeeded` 方法。

### 调用时机

1. **手动布局更新**：
   - 当你需要确保视图在某个时刻立即布局时，可以在需要的地方调用 `layoutIfNeeded` 方法。例如，在视图控制器的 `viewWillAppear` 或 `viewDidAppear` 方法中，有时需要确保视图已经正确布局后再执行某些操作。

2. **动画布局**：
   - 在使用 `UIView` 的动画方法（如 `animate(withDuration:animations:)`）时，你可以在动画代码块中使用 `layoutIfNeeded` 方法来确保动画执行过程中视图的布局是最新的。这可以避免动画执行过程中布局更新导致的不良效果。

3. **获取布局后的尺寸**：
   - 在某些情况下，你可能需要获取视图在特定时刻的布局后的尺寸或位置信息。在获取这些信息之前，可以调用 `layoutIfNeeded` 来确保已经进行了布局计算。

### 示例

```swift
class CustomView: UIView {
    func animateAndLayout() {
        UIView.animate(withDuration: 0.3) {
            // 在动画中更新约束或者属性
            self.layoutIfNeeded()
        }
    }
}
```

在这个示例中，当 `animateAndLayout` 方法被调用时，通过 `UIView` 的动画方法来执行动画，同时在动画块中调用 `layoutIfNeeded` 方法，确保在动画执行期间视图的布局是最新的。

### 总结

`layoutIfNeeded` 方法通常用于需要立即执行布局或确保在某些操作之前视图已经完成布局计算的情况下。它能够在需要时强制视图立即进行布局计算，并等待布局更新完成。




# setNeedsLayout

`setNeedsLayout` 是 `UIView` 的一个方法，用于标记视图需要重新布局。在标记之后，系统会在下一个布局周期中异步调用 `layoutSubviews` 方法。这个方法不会立即触发布局更新，但会在下一次运行循环中进行布局。调用 `setNeedsLayout` 的场景主要包括以下几种：

### 调用时机

1. **视图的属性发生变化**：
   - 当视图的某些属性（如 `frame`、`bounds`、`center` 等）发生变化时，你需要更新其子视图的布局。例如，如果你手动改变了视图的 `frame`，可以调用 `setNeedsLayout` 来确保子视图布局在下一个布局周期内更新。

2. **视图的内容发生变化**：
   - 如果视图的内容发生了变化，并且需要重新布局子视图。例如，视图中的文本、图像等内容变化后，需要调整子视图的位置或大小。

3. **响应外部事件**：
   - 当响应外部事件（如用户交互、通知等）需要更新视图的布局时。例如，用户点击按钮后需要调整其他视图的位置或大小。

4. **约束变化**：
   - 当使用 Auto Layout 并且视图的约束发生变化时，可以调用 `setNeedsLayout` 来触发重新布局。例如，你修改了视图的 NSLayoutConstraint 并希望立即生效。

### 示例

```swift
class CustomView: UIView {
    var someProperty: Int = 0 {
        didSet {
            // 当属性变化时，需要更新视图布局
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 在此处调整子视图的布局
        subview.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
    }
}
```

在这个示例中，当 `someProperty` 发生变化时，会调用 `setNeedsLayout` 方法，标记视图需要重新布局。然后在下一个布局周期中，系统会调用 `layoutSubviews` 方法，在该方法中可以调整子视图的布局。

### 总结

`setNeedsLayout` 方法用于标记视图需要重新布局，在标记后，系统会在下一个布局周期内异步调用 `layoutSubviews` 方法。它通常用于响应视图属性、内容或外部事件的变化，以确保子视图的布局是最新的。通过调用 `setNeedsLayout`，可以延迟布局更新，从而优化性能和减少不必要的布局计算。

**setNeedsLayout方法并不会立即刷新，立即刷新需要调用layoutIfNeeded方法！**
```
[self.view setNeedsLayout];
[self.view layoutIfNeeded];
```



# setNeedsDisplay

`setNeedsDisplay` 是 `UIView` 的一个方法，用于标记视图需要重新绘制。调用 `setNeedsDisplay` 方法会使系统在下一个绘制周期中调用视图的 `draw(_:)` 方法。这通常用于视图内容发生变化，需要重新绘制的情况。以下是一些常见的调用场景：

### 调用时机

1. **视图内容发生变化**：
   - 当视图的内容需要更新时（例如文本、图像或颜色等变化），可以调用 `setNeedsDisplay` 来标记视图需要重新绘制。例如，你在自定义视图中绘制了一个图形，如果图形的数据发生了变化，需要调用 `setNeedsDisplay` 重新绘制。

2. **视图的属性发生变化**：
   - 如果视图的某些属性（如背景色、透明度等）发生变化，且这些变化需要通过重新绘制才能反映出来。例如，你改变了视图的 `backgroundColor` 或 `alpha` 值，可以调用 `setNeedsDisplay` 重新绘制视图。

3. **响应外部事件**：
   - 当响应外部事件（如用户交互、通知等）需要更新视图的内容时。例如，用户点击按钮后，需要更新视图中显示的内容。

4. **动画效果**：
   - 在某些动画效果中，需要逐帧更新视图的内容。例如，你在一个自定义视图中实现动画，通过定时器或 CADisplayLink 调用 `setNeedsDisplay` 来逐帧重绘视图。

### 示例

```swift
class CustomView: UIView {
    var fillColor: UIColor = .red {
        didSet {
            // 当填充颜色变化时，标记视图需要重新绘制
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 在此处执行自定义绘制
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(fillColor.cgColor)
        context.fill(rect)
    }
}
```

在这个示例中，当 `fillColor` 属性变化时，会调用 `setNeedsDisplay` 方法，标记视图需要重新绘制。在下一个绘制周期中，系统会调用 `draw(_:)` 方法，在该方法中可以执行自定义绘制。

### 总结

`setNeedsDisplay` 方法用于标记视图需要重新绘制，在标记后，系统会在下一个绘制周期内调用 `draw(_:)` 方法。它通常用于视图内容或属性发生变化，需要通过重新绘制来反映这些变化的情况。通过调用 `setNeedsDisplay`，可以确保视图内容及时更新，保持与应用状态的一致性。




# drawRect

在iOS开发中，`drawRect:`方法是`UIView`类的一个实例方法，用于在自定义视图中绘制内容。`drawRect:`方法会在系统需要视图重绘时调用，比如视图首次显示或需要更新其内容时。以下是一些具体的场景：

### 何时调用`drawRect:`

1. **视图首次显示**：
   - 当视图首次显示在屏幕上时，系统会调用`drawRect:`方法来绘制视图的内容。

2. **视图内容需要更新**：
   - 当视图的内容发生变化，需要重新绘制时，系统会调用`drawRect:`方法。例如，调用`setNeedsDisplay`或`setNeedsDisplayInRect:`方法会标记视图为需要重绘，系统会在下一个绘制周期中调用`drawRect:`方法。

3. **视图尺寸变化**：
   - 当视图的尺寸发生变化时（例如，通过自动布局约束调整），系统可能会调用`drawRect:`方法以适应新的尺寸。

### 示例代码

以下是一个示例，演示如何在自定义视图中实现`drawRect:`方法：

```swift
import UIKit

class CustomView: UIView {

    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // 设置初始配置
    private func setup() {
        // 可以在这里进行一些初始配置
        backgroundColor = .white
    }

    // 绘制内容
    override func draw(_ rect: CGRect) {
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 设置绘图属性
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        
        // 绘制矩形
        let rectangle = CGRect(x: 10, y: 10, width: 100, height: 100)
        context.addRect(rectangle)
        context.strokePath()
    }
}
```

### 触发`drawRect:`

你可以通过以下方式触发视图的重绘，进而调用`drawRect:`方法：

1. **手动调用`setNeedsDisplay`**：
   - 标记整个视图为需要重绘。

    ```swift
    customView.setNeedsDisplay()
    ```

2. **手动调用`setNeedsDisplayInRect:`**：
   - 标记视图的特定区域为需要重绘。

    ```swift
    customView.setNeedsDisplay(in: CGRect(x: 10, y: 10, width: 50, height: 50))
    ```

### 注意事项

- `drawRect:`方法只应在视图内容需要更新时调用，避免不必要的性能开销。
- 不要直接调用`drawRect:`方法。相反，使用`setNeedsDisplay`或`setNeedsDisplayInRect:`来触发重绘。
- 在`drawRect:`方法中进行绘制操作时，应避免执行耗时任务，以保持界面流畅。
- 如果你的视图不需要自定义绘制，避免重写`drawRect:`方法，因为它会禁用视图的离屏渲染优化。

### 总结

`drawRect:`方法是用于在自定义视图中绘制内容的关键方法。它会在视图首次显示、内容需要更新或尺寸变化时由系统调用。通过合理使用`setNeedsDisplay`和`setNeedsDisplayInRect:`方法，你可以控制视图的重绘行为，确保应用界面的高效和流畅。







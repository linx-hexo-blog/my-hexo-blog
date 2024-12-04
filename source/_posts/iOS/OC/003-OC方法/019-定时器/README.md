---
title: iOS定时器
date: {{ date }}
tags:
- iOS
- 面试题
- 定时器
---

在 iOS 中，有多种方式可以实现定时器（Timer）功能，每种方式都有其适用的场景和特性。以下是几种常用的定时器实现方式：

### 1. `Timer`

`Timer` 是 Foundation 框架中的一个类，用于创建和管理定时器。它可以在指定的时间间隔内重复调用某个方法或执行某个闭包。

#### 使用示例

```swift
import Foundation

class TimerExample {
    var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        print("Timer fired!")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

let example = TimerExample()
example.startTimer()
```

#### 关键点

- `scheduledTimer(timeInterval:target:selector:userInfo:repeats:)`：创建并启动一个定时器。
- `invalidate()`：停止定时器。
- 定时器默认运行在默认模式（`default`）下，如果需要在滚动等操作时继续运行，需要添加到运行循环中的不同模式（例如 `RunLoop.Mode.common`）。

### 2. `CADisplayLink`

`CADisplayLink` 是 Core Animation 框架中的一个类，它允许你在屏幕刷新时执行某个方法，通常用于动画的逐帧更新。

#### 使用示例

```swift
import UIKit

class DisplayLinkExample {
    var displayLink: CADisplayLink?
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc func displayLinkFired() {
        print("DisplayLink fired!")
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

let example = DisplayLinkExample()
example.startDisplayLink()
```

#### 关键点

- `CADisplayLink`：与屏幕刷新率同步，非常适合用于动画。
- `add(to:forMode:)`：将 `CADisplayLink` 添加到运行循环。

### 3. `DispatchSourceTimer`

`DispatchSourceTimer` 是 GCD（Grand Central Dispatch）中的一个类，提供了一个更低级别的、基于块的定时器。

#### 使用示例

```swift
import Dispatch

class GCDTimerExample {
    var timer: DispatchSourceTimer?
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.example.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler {
            print("GCD Timer fired!")
        }
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

let example = GCDTimerExample()
example.startTimer()
```

#### 关键点

- `DispatchSourceTimer`：提供了一个非常灵活和高效的定时器解决方案。
- `schedule(deadline:repeating:)`：配置定时器的启动时间和重复间隔。
- `setEventHandler(handler:)`：设置定时器触发时执行的代码块。
- `resume()`：启动定时器。

### 4. `NSTimer`（旧版 `Timer`）

`NSTimer` 是 `Timer` 的旧版名称，在现代 Swift 代码中通常使用 `Timer` 作为替代。

#### 使用示例

```swift
import Foundation

class NSTimerExample {
    var timer: NSTimer?
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        print("NSTimer fired!")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

let example = NSTimerExample()
example.startTimer()
```

### 总结

- **`Timer`**：适合大多数定时任务，易于使用。
- **`CADisplayLink`**：适合需要与屏幕刷新率同步的任务，如动画。
- **`DispatchSourceTimer`**：适合需要高性能和高灵活性的场景。
- **`NSTimer`**：现代代码中通常使用 `Timer` 代替。

根据具体需求选择合适的定时器工具，可以更好地满足应用的性能和功能要求。
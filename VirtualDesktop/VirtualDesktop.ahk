#Requires AutoHotkey v2.0

; 定义虚拟桌面程序的路径
global VirtualDesktopPath := "./VirtualDesktop11-24H2.exe"

; 完全禁用 CapsLock 的默认行为
$CapsLock::return  ; 使用 $ 前缀防止热键被自身触发

; 捕获所有未定义的 CapsLock 组合键并忽略它们
~CapsLock & *::return  ; ~ 保留 CapsLock 的原始功能，* 捕获所有组合键

; 切换桌面和移动窗口到桌面的热键
CapsLock & 1::HandleDesktopAction(0)
CapsLock & 2::HandleDesktopAction(1)
CapsLock & 3::HandleDesktopAction(2)
CapsLock & 4::HandleDesktopAction(3)
CapsLock & 5::HandleDesktopAction(4)
CapsLock & 6::HandleDesktopAction(5)

; 新增的快捷键：CapsLock + F1 到 F6 移动窗口到指定桌面
CapsLock & F1::MoveActiveWindowToDesktop(0)
CapsLock & F2::MoveActiveWindowToDesktop(1)
CapsLock & F3::MoveActiveWindowToDesktop(2)
CapsLock & F4::MoveActiveWindowToDesktop(3)
CapsLock & F5::MoveActiveWindowToDesktop(4)
CapsLock & F6::MoveActiveWindowToDesktop(5)

; 固定/取消固定活动窗口到所有桌面：CapsLock+s
CapsLock & s::TogglePinActiveWindow()

; 左右切换桌面：CapsLock+左箭头 和 CapsLock+右箭头
CapsLock & Left::SwitchDesktopLeft()
CapsLock & Right::SwitchDesktopRight()

; 实现 CapsLock+Shift+q 实现 Alt+F4 的功能
CapsLock & q:: {
    if GetKeyState("Shift", "P") {
        Send("!{F4}")
    }
}

; 处理桌面切换或窗口移动的通用函数
HandleDesktopAction(desktopNumber) {
    KeyWait "CapsLock"  ; 等待 CapsLock 键释放
    KeyWait (desktopNumber + 1)  ; 等待数字键释放
    if GetKeyState("Shift", "P") {
        MoveActiveWindowToDesktop(desktopNumber)
    } else {
        SwitchDesktop(desktopNumber)
    }
}

; 切换桌面的函数
SwitchDesktop(desktopNumber) {
    global VirtualDesktopPath
    Run(VirtualDesktopPath " /Switch:" desktopNumber, "", "Hide")
    Sleep 100  ; 添加短暂延迟以确保操作完成
}

; 移动活动窗口到指定桌面的函数
MoveActiveWindowToDesktop(desktopNumber) {
    global VirtualDesktopPath
    Run(VirtualDesktopPath ' Q "/GETDESKTOP:Desktop ' (desktopNumber + 1) '" /MOVEACTIVEWINDOW /SWITCH', "", "Hide")
    Sleep 100  ; 添加短暂延迟以确保操作完成
}

; 固定/取消固定活动窗口到所有桌面的函数
TogglePinActiveWindow() {
    KeyWait "CapsLock"  ; 等待 CapsLock 键释放
    KeyWait "s"         ; 等待 s 键释放
    hwnd := WinExist("A")  ; 获取当前活动窗口句柄
    result := RunWait(VirtualDesktopPath " /IsWindowHandlePinned:" hwnd, "", "Hide")
    if (result = 0) {
        Run(VirtualDesktopPath " /UnPinActiveWindow", "", "Hide")
    } else {
        Run(VirtualDesktopPath " /PinActiveWindow", "", "Hide")
    }
    Sleep 100  ; 添加短暂延迟以确保操作完成
}

; 切换到左边桌面的函数
SwitchDesktopLeft() {
    KeyWait "CapsLock"  ; 等待 CapsLock 键释放
    KeyWait "Left"      ; 等待左箭头键释放
    global VirtualDesktopPath
    Run(VirtualDesktopPath " /Left", "", "Hide")
    Sleep 100  ; 添加短暂延迟以确保操作完成
}

; 切换到右边桌面的函数
SwitchDesktopRight() {
    KeyWait "CapsLock"  ; 等待 CapsLock 键释放
    KeyWait "Right"     ; 等待右箭头键释放
    global VirtualDesktopPath
    Run(VirtualDesktopPath " /Right", "", "Hide")
    Sleep 100  ; 添加短暂延迟以确保操作完成
}
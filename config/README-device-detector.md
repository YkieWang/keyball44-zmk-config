# Keyball44 设备检测器使用指南

本文档介绍了如何在Keyball44键盘上使用热插拔设备检测器功能。设备检测器能够自动识别连接到键盘的外部设备类型，并根据设备类型自动切换到相应的层。

## 基本功能

设备检测器可以识别以下类型的设备：

1. 旋钮设备 (Knob)
2. 摇杆设备 (Joystick)
3. 轨迹球设备 (Trackball)
4. 滑块设备 (Slider)
5. 其他设备 (Other)

当检测到设备变化时，设备检测器会自动切换到为该设备配置的层。

## 硬件连接

设备检测器通过ADC通道检测连接的设备类型。请按照以下步骤连接您的设备：

1. 使用分压电阻网络连接到nice!nano的ADC引脚（默认为P0.02/A2）
2. 不同设备应提供不同的电压值，以便设备检测器能够区分它们

### 分压电阻网络示例

对于不同设备，建议使用以下电阻值组合（从GND到VCC）：

- 旋钮设备: 1kΩ + 2kΩ = 约1.1V
- 摇杆设备: 2kΩ + 3kΩ = 约1.2V
- 轨迹球设备: 3kΩ + 3kΩ = 约1.65V
- 滑块设备: 4kΩ + 2kΩ = 约2.2V
- 其他设备: 5kΩ + 2kΩ = 约2.5V

## 配置

设备检测器已经在固件中配置好，默认情况下会自动启用。以下是相关的层配置：

- 旋钮设备: 层 4 (MOUSE)
- 摇杆设备: 层 5 (SCROLL)
- 轨迹球设备: 层 6 (SNIPE)
- 滑块设备: 层 7
- 其他设备: 层 0 (DEFAULT)

您可以在`keyball44.conf`文件中修改这些层设置。

## 自定义电压范围

如果需要自定义电压范围，可以通过shell命令或修改设备树文件来实现：

1. 使用shell命令自学习电压范围（推荐）：
   - 连接到键盘的串口控制台
   - 插入要校准的设备
   - 运行命令：`device_detector start_learning <type>`（type为1-5）
   - 移动设备以收集足够的样本
   - 运行命令：`device_detector finish_learning`保存结果

2. 手动修改设备树文件：
   - 编辑`keyball44_left.overlay`和`keyball44_right.overlay`文件
   - 修改`voltage-ranges`属性的值

## 问题排查

如果设备检测器不工作，请检查以下几点：

1. 确认ADC设置正确：设备检测器使用ADC通道2，请确保该通道可用
2. 检查电压值：使用命令`device_detector get_voltage`查看当前电压
3. 查看设备诊断：使用命令`device_detector diagnostics`查看详细信息
4. 如果出现错误检测，尝试使用自学习功能校准电压范围

## 命令参考

如果启用了shell支持，可以使用以下命令：

- `device_detector get_type` - 获取当前设备类型
- `device_detector get_voltage` - 获取当前电压
- `device_detector diagnostics` - 显示诊断信息
- `device_detector reset_diagnostics` - 重置诊断计数器
- `device_detector force_type <type>` - 强制设定设备类型
- `device_detector set_adaptive_stability <on|off>` - 启用/禁用自适应稳定性
- `device_detector start_learning <type>` - 开始学习某种设备类型的电压范围
- `device_detector finish_learning` - 完成学习并保存结果
- `device_detector learning_status` - 查看学习进度

## 进阶使用

设备检测器支持自适应稳定性检测，可以根据信号质量动态调整稳定性阈值。这在嘈杂环境中特别有用，可以提高检测可靠性。

如果您想在自己的代码中使用设备检测器API，请参考`zmk/drivers/device_detector.h`头文件中的函数定义。 
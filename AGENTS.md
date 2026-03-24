# AGENTS.md

This file provides guidance to codeflicker when working with code in this repository.

## WHY: 项目目标

这是 Keyball44 分体式机械键盘的 ZMK 固件配置仓库。Keyball44 由两个 Nice Nano v2 控制器组成，右半集成 PMW3610 光学轨迹球和 OLED 显示屏，通过 BLE 无线连接两半键盘。

## WHAT: 技术栈

- 固件框架：ZMK Firmware（自定义 fork：YkieWang/zmk，分支 feat/pointers-move-scroll-keyball41）
- 控制器：Nice Nano v2（nRF52840）× 2
- 鼠标驱动：inorichi/zmk-pmw3610-driver
- 配置格式：Devicetree (.dtsi/.overlay) + Kconfig (.conf) + Keymap (.keymap)
- 依赖管理：west（ZMK 官方工具）
- CI/CD：GitHub Actions（自动构建固件 + 生成键盘映射 SVG）

## HOW: 核心开发工作流

```bash
# 初始化工作区（首次）
west init -l config
west update

# 构建左半固件
west build -s zmk/app -d build/left -b nice_nano_v2 -- -DSHIELD=keyball44_left

# 构建右半固件（含 ZMK Studio）
west build -s zmk/app -d build/right -b nice_nano_v2 -- -DSHIELD=keyball44_right -DSNIPPET="studio-rpc-usb-uart"

# 构建设置重置固件
west build -s zmk/app -d build/reset -b nice_nano_v2 -- -DSHIELD=settings_reset
```

固件也可通过 push 到 GitHub 触发 Actions 自动构建，无需本地环境。

## Progressive Disclosure

详细信息请按需查阅：

- `docs/agent/architecture.md` - 硬件架构、图层设计、关键配置文件说明
- `docs/agent/development_commands.md` - 完整构建命令、CI/CD 工作流、固件刷写方法

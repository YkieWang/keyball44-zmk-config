# 架构说明

## 硬件架构

| 组件 | 型号 | 位置 |
|------|------|------|
| 微控制器 | Nice Nano v2 (nRF52840) | 左半 + 右半各一个 |
| 鼠标传感器 | PMW3610 光学传感器 | 右半，SPI 接口 |
| 显示屏 | SSD1306 OLED 128×32 | 左半，I2C 接口 |
| 按键矩阵 | 4 行 × 12 列，col2row 二极管方向 | 双半各半 |
| 无线连接 | BLE（右半为中央节点，左半为外围节点） | - |

## 项目文件结构

```
config/
├── west.yml                          # west 依赖清单（ZMK fork + PMW3610 驱动）
├── keyball44.conf                    # 全局 Kconfig（BLE、Studio、显示）
├── keyball44.keymap                  # 按键映射（8 个图层）
├── keyball44.json                    # 键盘物理布局定义（keymap-drawer 使用）
└── boards/shields/keyball_nano/
    ├── keyball44.dtsi                # 共享硬件设备树（矩阵、I2C OLED）
    ├── keyball44.zmk.yml             # Shield 元数据
    ├── keyball44_left.conf           # 左半 Kconfig
    ├── keyball44_left.overlay        # 左半设备树覆盖
    ├── keyball44_right.conf          # 右半 Kconfig（PMW3610 详细配置）
    ├── keyball44_right.overlay       # 右半设备树覆盖（SPI 传感器绑定）
    ├── Kconfig.defconfig             # Shield 默认 Kconfig 值
    └── Kconfig.shield                # Shield 选择逻辑
```

## 键盘图层设计

| 编号 | 名称 | 用途 |
|------|------|------|
| 0 | DEFAULT | QWERTY 主层，hold-tap 触发其他层 |
| 1 | NUM | 数字和常用符号 |
| 2 | SYM | Bluetooth 配置 + 功能键 |
| 3 | FUN | 数字小键盘 |
| 4 | MOUSE | 鼠标按键（click 等） |
| 5 | SCROLL | 轨迹球滚动模式 |
| 6 | SNIPE | 轨迹球精确（低速）模式 |
| 7 | （ZMK Studio） | ZMK Studio 保留层 |

## PMW3610 传感器关键配置（`keyball44_right.conf`）

| 参数 | 值 | 说明 |
|------|----|------|
| `CONFIG_PMW3610_CPI` | 1500 | 默认 DPI |
| `CONFIG_PMW3610_CPI_DIVIDOR` | 4 | 实际 CPI = 1500 / 4 = 375 |
| `CONFIG_PMW3610_SNIPE_CPI` | 400 | 精确模式 DPI |
| `CONFIG_PMW3610_ORIENTATION_180` | y | 传感器物理安装旋转 180° |
| `CONFIG_PMW3610_INVERT_SCROLL_X` | y | X 轴滚动方向取反 |
| `CONFIG_PMW3610_SCROLL_TICK` | 32 | 滚动步进精度 |
| `CONFIG_PMW3610_SMART_ALGORITHM` | y | 智能加速算法 |
| `CONFIG_PMW3610_POLLING_RATE_125_SW` | y | 软件 125Hz 轮询 |

scroll-layers 和 snipe-layers 在 `keyball44_right.overlay` 中绑定到图层 5（SCROLL）和 6（SNIPE）。

## BLE 优化配置（`keyball44.conf`）

- `CONFIG_BT_PERIPHERAL_PREF_MAX_INT=9`：降低连接间隔，减少延迟
- `CONFIG_BT_PERIPHERAL_PREF_LATENCY=16`：外围节点跳过轮询数
- `CONFIG_BT_BUF_ACL_TX_COUNT=32` / `CONFIG_BT_L2CAP_TX_BUF_COUNT=32`：增大缓冲区
- `CONFIG_BT_CTLR_TX_PWR_PLUS_8=y`：最大发射功率（+8 dBm）
- `CONFIG_ZMK_BLE_EXPERIMENTAL_FEATURES=y` + `CONFIG_ZMK_BLE_EXPERIMENTAL_CONN=y`

## ZMK Studio

- 右半启用 `CONFIG_ZMK_STUDIO=y`，锁定关闭（`CONFIG_ZMK_STUDIO_LOCKING=n`）
- 构建右半时需附加 snippet：`-DSNIPPET="studio-rpc-usb-uart"`
- `build.yaml` 中右半自动包含此 snippet

## 自定义行为

`keyball44.keymap` 中定义了：
- `cmqus`：逗号/问号 mod-morph（按住 Shift 时输出 `?`）
- `dtsmi`：句点/分号 mod-morph（按住 Shift 时输出 `;`）
- `relay_512` 宏：自定义按键序列宏

## 可视化生成

- `keymap_drawer.config.yaml`（559 行）：高度自定义的 keymap-drawer 配置
- 通过 GitHub Actions（`.github/workflows/keymap_drawer.yml`）自动生成 `keymap-drawer/keyball44.svg`
- 触发条件：推送修改 `keymap_drawer.config.yaml` 或 `config/**` 的提交

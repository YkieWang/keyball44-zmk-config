# 开发命令

## 本地构建（需要 ZMK 本地环境）

> 通常推荐直接 push 到 GitHub 触发自动构建，无需本地搭建 ZMK 环境。

```bash
# 初始化 west 工作区（首次执行）
west init -l config
west update

# 构建左半固件
west build -s zmk/app -d build/left -b nice_nano_v2 -- -DSHIELD=keyball44_left

# 构建右半固件（含 ZMK Studio RPC over USB-UART）
west build -s zmk/app -d build/right -b nice_nano_v2 -- -DSHIELD=keyball44_right -DSNIPPET="studio-rpc-usb-uart"

# 构建设置重置固件（用于清除配对信息）
west build -s zmk/app -d build/reset -b nice_nano_v2 -- -DSHIELD=settings_reset

# 依赖更新
west update
```

## 固件刷写

Nice Nano v2 使用 UF2 引导程序：

1. 双击 RESET 按钮进入引导程序模式（会出现名为 `NICENANO` 的 U 盘）
2. 将 `build/left/zephyr/zmk.uf2` 或 `build/right/zephyr/zmk.uf2` 复制到该 U 盘
3. 设备自动重启并加载新固件

## GitHub Actions 自动构建

**推荐工作流**：修改配置文件后直接 push，Actions 自动构建并上传固件。

```bash
git add config/
git commit -m "描述改动"
git push
```

构建完成后在 GitHub Actions 的 Artifacts 中下载 `.uf2` 文件。

**构建矩阵**（`build.yaml`）：

| Shield | Board | Snippet | 用途 |
|--------|-------|---------|------|
| keyball44_left | nice_nano_v2 | - | 左半固件 |
| keyball44_right | nice_nano_v2 | studio-rpc-usb-uart | 右半固件（含 Studio）|
| settings_reset | nice_nano_v2 | - | 重置配对信息 |

## 键盘映射可视化生成

GitHub Actions 在修改 `config/**` 或 `keymap_drawer.config.yaml` 时自动触发：

```bash
# 手动触发（通过 GitHub Actions 界面 workflow_dispatch）
# 或本地安装 keymap-drawer 后执行：
keymap -c keymap_drawer.config.yaml parse -z config/keyball44.keymap > keymap-drawer/keyball44.yaml
keymap -c keymap_drawer.config.yaml draw keymap-drawer/keyball44.yaml > keymap-drawer/keyball44.svg
```

生成结果保存在 `keymap-drawer/keyball44.svg`。

## ZMK Studio 使用

启动 ZMK Studio 进行实时键盘配置修改（无需重新编译固件）：

1. 使用 USB 连接右半键盘到电脑
2. 打开 [ZMK Studio](https://zmk.studio)
3. 选择串口连接
4. 实时修改按键映射，保存后自动写入键盘

注意：`CONFIG_ZMK_STUDIO_LOCKING=n` 已关闭锁定，无需解锁操作。

## 常用配置修改

| 修改内容 | 对应文件 |
|---------|---------|
| 按键映射/图层 | `config/keyball44.keymap` |
| 鼠标 DPI/行为 | `config/boards/shields/keyball_nano/keyball44_right.conf` |
| BLE/全局功能 | `config/keyball44.conf` |
| 硬件引脚/设备 | `config/boards/shields/keyball_nano/keyball44.dtsi` |
| 依赖版本 | `config/west.yml` |

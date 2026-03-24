# keyball44-zmk-config

![my keymap](https://github.com/YkieWang/keyball44-zmk-config/blob/main/keymap-drawer/keyball44.svg "my keymap")

---

## Build Log

记录每次固定（pin）ZMK 版本的时间、commit 及验证结果。
Tracks each ZMK version pin with build date and verification status.

| 日期 Date | ZMK Commit | Zephyr 版本 Version | 构建结果 Result | 备注 Notes |
|-----------|------------|---------------------|-----------------|------------|
| 2026-03-24 | [`197f8997`](https://github.com/zmkfirmware/zmk/commit/197f8997776c960b6d2d368909895735f859a4b4) | 4.1.0 | ✅ 通过 Pass | 迁移至官方 ZMK，启用 Zephyr 内置 PMW3610 驱动及 input-processors<br>Migrated to official ZMK with Zephyr built-in PMW3610 driver and input-processors |

> 如需升级 ZMK 版本，在 `config/west.yml` 中将 `revision` 改为新的 commit hash，并在上表补充记录。
>
> To upgrade ZMK, update `revision` in `config/west.yml` to the new commit hash and add a row to the table above.

---

## 轨迹球驱动方案对比 / Trackball Driver Comparison

本仓库 `feat/migrate-to-official-zmk` 分支使用 **Zephyr 内置 PMW3610 驱动 + ZMK input-processors**，与原方案（`zmk-pmw3610-driver` 第三方驱动）有如下区别。

The `feat/migrate-to-official-zmk` branch uses **Zephyr built-in PMW3610 driver + ZMK input-processors**, compared to the original approach using the third-party `zmk-pmw3610-driver` module.

| 功能 Feature | 第三方驱动 Third-party (`inorichi/zmk-pmw3610-driver`) | Zephyr 内置驱动 Built-in + input-processors |
|---|---|---|
| ZMK 版本兼容性<br>ZMK compatibility | 基于旧版 ZMK fork（Zephyr 3.5）<br>Based on old ZMK fork (Zephyr 3.5) | 官方 ZMK main（Zephyr 4.1），持续更新<br>Official ZMK main (Zephyr 4.1), kept up to date |
| ZMK Studio 支持<br>ZMK Studio support | 需自定义 workflow，UART 连接<br>Requires custom workflow, UART connection | 官方 snippet `studio-rpc-usb-uart`，USB 直连<br>Official snippet, USB direct connection |
| CPI 配置<br>CPI configuration | `CONFIG_PMW3610_CPI` + `CONFIG_PMW3610_CPI_DIVIDOR`，Kconfig 静态配置<br>Static Kconfig options | `res-cpi` devicetree 属性 + `zip_xy_scaler` 软件缩放<br>`res-cpi` DTS property + `zip_xy_scaler` software scaling |
| 旋转/朝向<br>Orientation | `CONFIG_PMW3610_ORIENTATION_180=y`，一键配置<br>Single Kconfig option | `invert-x` / `invert-y` devicetree 属性<br>`invert-x` / `invert-y` DTS properties |
| 滚动层<br>Scroll layer | `scroll-layers = <5>` 在 overlay 中声明<br>Declared in overlay | `zip_xy_to_scroll_mapper`，在 `trackball_listener` 子节点配置<br>Configured via `trackball_listener` child node |
| Snipe 精确模式<br>Snipe mode | `CONFIG_PMW3610_SNIPE_CPI=400`，独立硬件 CPI 档<br>Dedicated hardware CPI value | `zip_xy_scaler 1 8` 软件缩放，无独立 CPI 档<br>Software scaling only, no dedicated CPI level |
| 滚动步进精度<br>Scroll tick | `CONFIG_PMW3610_SCROLL_TICK=32` | 不支持<br>Not supported |
| 轮询率<br>Polling rate | `CONFIG_PMW3610_POLLING_RATE_125_SW=y`，软件 125Hz<br>Software 125Hz | 不支持额外配置<br>Not configurable |
| 省电/休眠<br>Power saving | `CONFIG_PMW3610_RUN_DOWNSHIFT_TIME_MS` 等细粒度配置<br>Fine-grained sleep timing options | 不支持<br>Not supported |
| 智能算法<br>Smart algorithm | `CONFIG_PMW3610_SMART_ALGORITHM=y` | `smart-mode` devicetree 属性<br>`smart-mode` DTS property |
| 依赖管理<br>Dependency | 需在 `west.yml` 添加第三方模块<br>Requires third-party module in `west.yml` | 无额外依赖，Zephyr 上游内置<br>No extra dependency, built into Zephyr upstream |

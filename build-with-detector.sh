#!/bin/bash
# 构建包含设备检测器的固件

# 确保west工具已安装
if ! command -v west &> /dev/null; then
    echo "错误: 未找到west工具。请确保已安装ZMK开发环境。"
    exit 1
fi

# 更新west modules
echo "正在更新west modules..."
cd config
west update
cd ..

# 构建左半键盘固件
echo "正在构建左半键盘固件..."
west build -d build-left -b nice_nano_v2 -- -DSHIELD=keyball44_left -DZMK_CONFIG="$(pwd)/config"
if [ $? -ne 0 ]; then
    echo "错误: 左半键盘固件构建失败！"
    exit 1
fi
echo "左半键盘固件构建成功！"

# 复制左半键盘固件
cp build-left/zephyr/zmk.uf2 keyball44_left-device-detector.uf2
echo "左半键盘固件已保存为: keyball44_left-device-detector.uf2"

# 构建右半键盘固件
echo "正在构建右半键盘固件..."
west build -d build-right -b nice_nano_v2 -- -DSHIELD=keyball44_right -DZMK_CONFIG="$(pwd)/config"
if [ $? -ne 0 ]; then
    echo "错误: 右半键盘固件构建失败！"
    exit 1
fi
echo "右半键盘固件构建成功！"

# 复制右半键盘固件
cp build-right/zephyr/zmk.uf2 keyball44_right-device-detector.uf2
echo "右半键盘固件已保存为: keyball44_right-device-detector.uf2"

echo "构建完成！固件文件:"
echo "- keyball44_left-device-detector.uf2"
echo "- keyball44_right-device-detector.uf2" 
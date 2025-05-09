#!/bin/bash
# 构建包含设备检测器的固件

# 更新本地分支
echo "正在更新本地分支..."
git fetch origin
git checkout sputnik
git pull origin sputnik

# 推送到GitHub触发Actions构建
echo "正在推送到GitHub..."
git push origin sputnik

echo "构建已触发，请在GitHub Actions页面查看构建状态:"
echo "https://github.com/YkieWang/keyball44-zmk-config/actions"
echo "构建完成后，可以从Actions页面下载固件文件"

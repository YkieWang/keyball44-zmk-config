/*
 * Copyright (c) 2023 ZMK Contributors
 *
 * SPDX-License-Identifier: MIT
 */

#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/logging/log.h>
#include <zmk/drivers/device_detector.h>

LOG_MODULE_REGISTER(device_detector_test, CONFIG_ZMK_LOG_LEVEL);

// 当设备类型变化时的回调函数
static void device_type_changed_cb(enum device_type type, void *user_data) {
    LOG_INF("设备类型变化为: %s", device_type_to_str(type));
}

// 初始化函数
static int device_detector_test_init(const struct device *dev) {
    // 获取设备检测器设备
    const struct device *detector = DEVICE_DT_GET(DT_CHOSEN(zmk_device_detector));
    
    if (!device_is_ready(detector)) {
        LOG_ERR("设备检测器未就绪");
        return -ENODEV;
    }
    
    LOG_INF("设备检测器已就绪");
    
    // 注册回调
    int err = device_detector_register_callback(detector, device_type_changed_cb, NULL);
    if (err) {
        LOG_ERR("注册回调失败: %d", err);
        return err;
    }
    
    LOG_INF("设备检测器测试初始化完成");
    
    return 0;
}

SYS_INIT(device_detector_test_init, APPLICATION, CONFIG_APPLICATION_INIT_PRIORITY); 
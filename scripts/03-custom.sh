#!/bin/bash
# =========================================================
# 03-custom.sh
# 系统默认出厂参数、默认 IP、时区与主机名微调
# =========================================================

set -e

echo ">>> 配置系统出厂默认参数..."

CONFIG_GEN="package/base-files/files/bin/config_generate"

if [ -f "$CONFIG_GEN" ]; then
    # 1. 默认 LAN IP 设置为 10.0.0.1 (规避光猫 192.168.1.1 冲突)
    sed -i 's/192.168.1.1/10.0.0.1/g' "$CONFIG_GEN"

    # 2. 默认主机名设置为 R4S-Router
    sed -i 's/ImmortalWrt/R4S-Router/g' "$CONFIG_GEN"
    sed -i 's/OpenWrt/R4S-Router/g' "$CONFIG_GEN"

    # 3. 默认时区设置为中国标准时间 (东八区 Asia/Shanghai)
    sed -i "s/'UTC'/'CST-8'/g" "$CONFIG_GEN"
    sed -i "/set system.@system\[-1\].timezone='CST-8'/a \set system.@system[-1].zonename='Asia/Shanghai'" "$CONFIG_GEN"
fi

# 4. 优化国内常用 NTP 服务器
sed -i 's/0.openwrt.pool.ntp.org/ntp.aliyun.com/g' package/base-files/files/etc/config/system 2>/dev/null || true
sed -i 's/1.openwrt.pool.ntp.org/time1.cloud.tencent.com/g' package/base-files/files/etc/config/system 2>/dev/null || true

echo ">>> 03-custom.sh 执行完毕"

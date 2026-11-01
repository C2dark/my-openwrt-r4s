#!/bin/bash
# =========================================================
# 01-feeds.sh
# 注入外部第三方 Feed 源与专用驱动源码
# =========================================================

set -e

# 1. 注入 OpenWrt-nikki (Mihomo 现代客户端) 源码
echo ">>> 添加 nikki feed..."
if ! grep -q "OpenWrt-nikki" feeds.conf.default; then
    echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >> feeds.conf.default
fi

# 2. 注入 Realtek RTL8812BU (rtl88x2bu) USB 无线网卡驱动
echo ">>> 拉取 RTL8812BU 无线网卡驱动..."
rm -rf package/kernel/wireless-drivers
git clone --depth 1 https://github.com/sbwml/openwrt-wireless-drivers package/kernel/wireless-drivers || {
    echo "备用源克隆 rtl88x2bu-cl..."
    git clone --depth 1 https://github.com/mirobiala/rtl88x2bu-cl package/kernel/rtl88x2bu-cl
}

echo ">>> 01-feeds.sh 执行完毕"

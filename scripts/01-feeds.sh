#!/bin/bash
# =========================================================
# 01-feeds.sh
# 注入外部第三方 Feed 源
# =========================================================

set -e

# 注入 OpenWrt-nikki (Mihomo 现代客户端) 源码
echo ">>> 添加 nikki feed..."
if ! grep -q "OpenWrt-nikki" feeds.conf.default; then
    echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >> feeds.conf.default
fi

echo ">>> 01-feeds.sh 执行完毕"

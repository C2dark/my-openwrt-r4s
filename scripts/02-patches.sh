#!/bin/bash
# =========================================================
# 02-patches.sh
# 针对 NanoPi R4S 的硬件稳定性修正与补丁
# 解决标准版 R4S 缺少次网卡 EEPROM 导致重启 MAC 随机漂移的问题
# =========================================================

set -e

echo ">>> 注入 NanoPi R4S 稳定 MAC 地址生成逻辑..."

# 确保目标目录存在
mkdir -p package/base-files/files/etc/uci-defaults

# 编写首次开机初始化脚本 (以 eth0 芯片唯一硬件 MAC 为基准，稳定递增生成 eth1 MAC)
cat > package/base-files/files/etc/uci-defaults/99-fix-r4s-mac << 'EOF'
#!/bin/sh

# 检查当前是否为 NanoPi R4S
board=$(cat /tmp/sysinfo/board_name 2>/dev/null || true)
case "$board" in
    *nanopi-r4s*)
        if [ -f /sys/class/net/eth0/address ]; then
            base_mac=$(cat /sys/class/net/eth0/address)
            # 解析最后一段十六进制并递增 1 生成唯一的次网卡 MAC
            prefix=$(echo "$base_mac" | cut -d: -f1-5)
            last_byte=$(echo "$base_mac" | cut -d: -f6)
            next_byte=$(printf "%02x" $(( (0x$last_byte + 1) % 256 )))
            stable_lan_mac="${prefix}:${next_byte}"

            # 绑定固定 MAC 到 lan 接口配置中
            uci set network.lan.macaddr="$stable_lan_mac"
            uci commit network
            logger -t "r4s-mac" "Successfully fixed stable LAN MAC: $stable_lan_mac based on WAN: $base_mac"
        fi
        ;;
esac

exit 0
EOF

chmod 755 package/base-files/files/etc/uci-defaults/99-fix-r4s-mac

echo ">>> 02-patches.sh 执行完毕"

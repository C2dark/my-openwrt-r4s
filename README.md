# NanoPi R4S (4GB) 专属 OpenWrt 现代化固件构建项目

基于 **ImmortalWrt Master（Linux 6.12 LTS 原生内核 + 全新 APK 包管理器）**，针对 **FriendlyARM NanoPi R4S (4GB 版)** 进行专门调校的轻量化自动化云编译固件体系。

---

## 🌟 固件核心特性

* **现代内核与包管理器**：搭载 **Linux 6.12 LTS** 现代主线内核，全面采用更高效、更轻快的 **APK (Alpine Package Keeper 3.0)** 包管理器。
* **RTL8812BU 专属驱动**：深度集成 Realtek **RTL8812BU (AC1200 / AC1300)** USB 3.0 无线网卡驱动与 `wpad-basic-mbedtls`，插入即用，自动点亮 Web 后台双频无线控制面板。
* **硬件级稳定 MAC 补丁**：解决标准版 R4S 缺乏次网卡 EEPROM 导致重启 MAC 随机漂移的顽疾，开机自动以 CPU 唯一硬件序列号绑定固定稳定 MAC。
* **防 IP 网段冲突**：出厂默认后台 IP 设为 **`10.0.0.1`**，彻底规避主流光猫与二级路由的 `192.168.1.1` 冲突。
* **双文件系统输出**：每批次构建同时生成 **SquashFS**（只读出厂防变砖，推荐）与 **Ext4**（全盘可读写，大分区）双格式。

---

## 📦 三大版本层级说明

| 版本名称 | 定位与特色 | 核心预装内容 |
| :--- | :--- | :--- |
| **Origin (纯净版)** | 纯净底层系统，完全零应用插件 | 仅包含经过精简优化的系统核心、Argon 主题与基础网络工具。所有软件后续自行使用 `apk add` 按需安装。 |
| **Plus (推荐日常版)** | 对标原 openwrt-lite 精选轻量工具 | • **无线支持**：RTL8812BU 驱动套件<br>• **核心代理**：[OpenWrt-nikki](https://github.com/nikkinikki-org/OpenWrt-nikki) (基于 Mihomo 内核)<br>• **组网远程**：Tailscale、DDNS、Socat<br>• **网络优化**：UPnP、EQoS (轻量流控)、TTYD (网页终端)、流量监控 |
| **Pro (全能服务器版)** | 充分利用 4GB 内存打造 All-in-One 路由 | 包含 Plus 的全部特性，额外增设：<br>• **容器服务**：Docker 全家桶 (Dockerman / compose / cgroupfs)<br>• **文件共享**：Samba4 局域网共享、磁盘挂载管理 (Diskman)<br>• **扩展协议**：WireGuard、Watchcat (断网保活) |

---

## 🚀 编译与使用方法

### 1. 快速使用（GitHub Actions 云编译）

1. **Fork 本仓库**到你的个人 GitHub 账号下。
2. 进入你的仓库页面，点击上方的 **Actions** 标签。
3. 在左侧选择 **`Build NanoPi R4S Firmware`** 工作流。
4. 点击右侧的 **Run workflow**：
   * **版本选择**：下拉菜单选择你要构建的版本（`Plus` / `Origin` / `Pro` / `All`）。
   * **自定义 LAN IP**：默认是 `10.0.0.1`，如有特殊需求可输入自定义地址。
5. 等待 GitHub 云端自动完成编译（通常约 1.5~2 小时），编译完成后将自动在 **Releases** 页面发布打包好的固件文件与 SHA256 校验清单。

---

## 📝 首次开机与默认配置

```text
默认管理地址：10.0.0.1
默认登录用户：root
默认登录密码：空 (直接回车即可登录)
默认无线 Wi-Fi：插入 RTL8812BU USB 无线网卡后，在后台「网络 -> 无线」中开启启用
```

### 刷机指引：
1. 准备一张 8GB 及以上的高速 MicroSD (TF) 卡。
2. 在 Releases 下载带 `squashfs-sysupgrade.img.gz` 的文件（无需解压）。
3. 使用 [balenaEtcher](https://etcher.balena.io/) 或 [Rufus](https://rufus.ie/) 将固件直接写入 TF 卡。
4. 将 TF 卡插入 NanoPi R4S，网线连接电脑与 R4S 的 **LAN 口**（靠近 USB 口那一侧），接通 Type-C 电源。
5. 电脑获取到 `10.0.0.x` 的 IP 后，在浏览器访问 `http://10.0.0.1` 即可进入管理后台。

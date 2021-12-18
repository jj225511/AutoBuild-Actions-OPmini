#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions>
# AutoBuild DiyScript

Firmware_Diy_Core() {

	Author=ZYZH
	Author_URL=https://github.com/jj225511
	Default_IP="192.168.5.1"
	Banner_Message="Powered by ZYZH"

	Short_Firmware_Date=false
	Checkout_Virtual_Images=false
	Firmware_Format=AUTO
	REGEX_Skip_Checkout="packages|buildinfo|sha256sums|manifest|kernel|rootfs|factory"

	INCLUDE_AutoBuild_Features=false
	INCLUDE_DRM_I915=false
	INCLUDE_Original_OpenWrt_Compatible=true
}

Firmware_Diy() {

	# 请在该函数内定制固件, 建议使用专业文本编辑器进行修改

	# 可用预设变量, 其他可用变量请参考运行日志
	# ${OP_AUTHOR}			OpenWrt 源码作者
	# ${OP_REPO}			OpenWrt 仓库名称
	# ${OP_BRANCH}			OpenWrt 源码分支
	# ${TARGET_PROFILE}		设备名称, 例如: d-team_newifi-d2
	# ${TARGET_BOARD}		设备架构, 例如: ramips

	# ${Home}				OpenWrt 源码位置
	# ${FEEDS_CONF}			[feeds.conf.default] 文件
	# ${CustomFiles}		仓库中的 /CustomFiles 绝对路径
	# ${Scripts}			仓库中的 /Scripts 绝对路径
	# ${FEEDS_LUCI}			OpenWrt 源码目录下的 package/feeds/luci
	# ${FEEDS_PKG}			OpenWrt 源码目录下的 package/feeds/packages
	# ${BASE_FILES}			俗称替换大法的路径, 位于 package/base-files/files

	case "${OP_Maintainer}/${OP_REPO_NAME}:${OP_BRANCH}" in
	coolsnowwolf/lede:master)
		sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${feeds_pkgs}/ttyd/files/ttyd.config
	;;
	esac

	case "${TARGET_PROFILE}" in
	d-team_newifi-d2)
		patch -i ${CustomFiles}/mac80211_d-team_newifi-d2.patch package/kernel/mac80211/files/lib/wifi/mac80211.sh
		Copy ${CustomFiles}/system_d-team_newifi-d2 ${base_files}/etc/config system
		#sed -i 's/OpenWrt/ZYZH-Router/g' package/base-files/files/bin/config_generate
		[[ ${OP_REPO_NAME} == lede ]] && sed -i "/DEVICE_COMPAT_VERSION := 1.1/d" target/linux/ramips/image/mt7621.mk
	;;
	esac
        sed -i 's/OpenWrt/ZYZH-Router/g' package/base-files/files/bin/config_generate
	sed -i 's/OpenWrt/ZYZH-Router/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
}

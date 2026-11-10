#!/bin/bash
#私有扩展脚本：上游 Packages.sh 末尾会 source 本文件（当前目录为源码根目录 ./wrt）
#上游没有这个文件，同步上游时不会冲突

#SoftEtherVPN 5 升级到指定版本（feeds 里的 softethervpn5 版本较旧）
SE_VER="5.2.5189"
SE_HASH="90607665e5e71ff7b1423915b9eb18b56e544caaf0a258e1f0787de75008833a"
SE_DIR=$(find ./feeds/packages/ -maxdepth 3 -type d -name "softethervpn5" | head -n 1)

if [ -n "$SE_DIR" ] && [ -f "$SE_DIR/Makefile" ]; then
	SE_OLD=$(grep -Po "^PKG_VERSION:=\K.*" "$SE_DIR/Makefile")
	if dpkg --compare-versions "$SE_OLD" lt "$SE_VER"; then
		sed -i "s/^PKG_VERSION:=.*/PKG_VERSION:=$SE_VER/; s/^PKG_RELEASE:=.*/PKG_RELEASE:=1/; s/^PKG_HASH:=.*/PKG_HASH:=$SE_HASH/" "$SE_DIR/Makefile"
		#5.2.5189 已合并“允许关闭 OQS”的补丁，旧补丁不再需要
		rm -f "$SE_DIR"/patches/001-Mayaqua-build-allow-disabling-OQS.patch
		echo "softethervpn5: $SE_OLD -> $SE_VER"
	else
		echo "softethervpn5: feeds 版本 $SE_OLD 已不低于 $SE_VER，不做修改"
	fi
else
	echo "softethervpn5 not found!"
fi

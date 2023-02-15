# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from VirtualBox-*.run
# XXX: update: now it is split from virtualbox-*-Debian~bullseye_amd64.deb

EAPI=8

inherit linux-mod toolchain-funcs

MY_P="vbox-kernel-module-src-${PV}"
DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"

BUILD_TARGETS="all"
MODULE_NAMES="vboxdrv(misc:${S}) vboxnetflt(misc:${S}) vboxnetadp(misc:${S})"
MODULESD_VBOXDRV_ENABLED="yes"
MODULESD_VBOXNETADP_ENABLED="no"
MODULESD_VBOXNETFLT_ENABLED="no"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="CC=\"$(tc-getBUILD_CC)\" KERN_DIR=${KV_DIR} KERN_VER=${KV_FULL} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
	if linux_chkconfig_present CC_IS_CLANG; then
		ewarn "Warning: building ${PN} with a clang-built kernel is experimental."

		BUILD_PARAMS+=' CC=${CHOST}-clang'
		if linux_chkconfig_present LD_IS_LLD; then
			BUILD_PARAMS+=' LD=ld.lld'
			if linux_chkconfig_present LTO_CLANG_THIN; then
				# kernel enables cache by default leading to sandbox violations
				BUILD_PARAMS+=' ldflags-y=--thinlto-cache-dir= LDFLAGS_MODULE=--thinlto-cache-dir='
			fi
		fi
	fi
}

src_install() {
	linux-mod_src_install
	insinto /usr/lib/modules-load.d/
	newins "${FILESDIR}"/virtualbox.conf-r1 virtualbox.conf
}

pkg_postinst() {
	# Remove vboxpci.ko from current running kernel
	# This module is obsolete, removed in december 2019, so it may be missing.  No || die
	# TODO: consider removing this line in the near future
	find /lib/modules/${KV_FULL}/misc -type f -name "vboxpci.ko" -delete
	linux-mod_pkg_postinst
}

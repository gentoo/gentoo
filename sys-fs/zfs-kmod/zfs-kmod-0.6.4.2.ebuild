# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/zfs-kmod/zfs-kmod-0.6.4.2.ebuild,v 1.2 2015/07/14 03:17:14 dlan Exp $

EAPI="4"

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit flag-o-matic linux-info linux-mod toolchain-funcs autotools-utils

if [ ${PV} == "9999" ] ; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/zfsonlinux/zfs.git"
else
	inherit eutils versionator
	SRC_URI="https://github.com/zfsonlinux/zfs/archive/zfs-${PV}.tar.gz"
	S="${WORKDIR}/zfs-zfs-${PV}"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="CDDL debug? ( GPL-2+ )"
SLOT="0"
IUSE="custom-cflags debug +rootfs"
RESTRICT="debug? ( strip ) test"

DEPEND="
	=sys-kernel/spl-${PV}*
	dev-lang/perl
	virtual/awk
"

RDEPEND="${DEPEND}
	!sys-fs/zfs-fuse
"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="!DEBUG_LOCK_ALLOC
		BLK_DEV_LOOP
		EFI_PARTITION
		IOSCHED_NOOP
		MODULES
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
		!PAX_USERCOPY_SLABS
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"

	use debug && CONFIG_CHECK="${CONFIG_CHECK}
		FRAME_POINTER
		DEBUG_INFO
		!DEBUG_INFO_REDUCED
	"

	use rootfs && \
		CONFIG_CHECK="${CONFIG_CHECK}
			BLK_DEV_INITRD
			DEVTMPFS
	"

	kernel_is ge 2 6 32 || die "Linux 2.6.32 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 4 1 || die "Linux 4.1 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	# Remove GPLv2-licensed ZPIOS unless we are debugging
	use debug || sed -e 's/^subdir-m += zpios$//' -i "${S}/module/Makefile.in"

	# Set module revision number
	[ ${PV} != "9999" ] && \
		{ sed -i "s/\(Release:\)\(.*\)1/\1\2${PR}-gentoo/" "${S}/META" || die "Could not set Gentoo release"; }

	autotools-utils_src_prepare
}

src_configure() {
	local SPL_PATH="$(basename $(echo "${EROOT}usr/src/spl-"*))"
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	set_arch_to_kernel
	local myeconfargs=(${myeconfargs}
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=kernel
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		--with-spl="${EROOT}usr/src/${SPL_PATH}"
		--with-spl-obj="${EROOT}usr/src/${SPL_PATH}/${KV_FULL}"
		$(use_enable debug)
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install INSTALL_MOD_PATH="${INSTALL_MOD_PATH:-$EROOT}"
	dodoc AUTHORS COPYRIGHT DISCLAIMER README.markdown
}

pkg_postinst() {
	linux-mod_pkg_postinst

	# Remove old modules
	if [ -d "${EROOT}lib/modules/${KV_FULL}/addon/zfs" ]
	then
		ewarn "${PN} now installs modules in ${EROOT}lib/modules/${KV_FULL}/extra/zfs"
		ewarn "Old modules were detected in ${EROOT}lib/modules/${KV_FULL}/addon/zfs"
		ewarn "Automatically removing old modules to avoid problems."
		rm -r "${EROOT}lib/modules/${KV_FULL}/addon/zfs" || die "Cannot remove modules"
		rmdir --ignore-fail-on-non-empty "${EROOT}lib/modules/${KV_FULL}/addon"
	fi

	if use x86 || use arm
	then
		ewarn "32-bit kernels will likely require increasing vmalloc to"
		ewarn "at least 256M and decreasing zfs_arc_max to some value less than that."
	fi

	ewarn "This version of ZFSOnLinux includes support for new feature flags"
	ewarn "that are incompatible with ZFSOnLinux 0.6.3 and GRUB2 support for"
	ewarn "/boot with the new feature flags is not yet available."
	ewarn "Do *NOT* upgrade root pools to use the new feature flags."
	ewarn "Any new pools will be created with the new feature flags by default"
	ewarn "and will not be compatible with older versions of ZFSOnLinux. To"
	ewarn "create a newpool that is backward compatible, use "
	ewarn "zpool create -o version=28 ..."
	ewarn "Then explicitly enable older features. Note that the LZ4 feature has"
	ewarn "been upgraded to support metadata compression and has not been"
	ewarn "tested against the older GRUB2 code base. GRUB2 support will be"
	ewarn "updated as soon as the GRUB2 developers and Open ZFS community write"
	ewarn "GRUB2 patchese that pass mutual review."
}

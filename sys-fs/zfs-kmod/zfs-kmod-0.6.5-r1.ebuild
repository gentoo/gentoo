# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
		{ kernel_is le 4 2 || die "Linux 4.2 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	if [ ${PV} != "9999" ]
	then
		# Fix zvol data loss regression
		# https://github.com/zfsonlinux/zfs/pull/3798
		epatch "${FILESDIR}/${P}-discard-on-zvol-fix.patch"
	fi

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
	ewarn "that are incompatible with previous versions. GRUB2 support for"
	ewarn "/boot with the new feature flags is not yet available."
	ewarn "Do *NOT* upgrade root pools to use the new feature flags."
	ewarn "Any new pools will be created with the new feature flags by default"
	ewarn "and will not be compatible with older versions of ZFSOnLinux. To"
	ewarn "create a newpool that is backward compatible wih GRUB2, use "
	ewarn
	ewarn "zpool create -d -o feature@async_destroy=enabled "
	ewarn "	-o feature@empty_bpobj=enabled -o feature@lz4_compress=enabled"
	ewarn "	-o feature@spacemap_histogram=enabled"
	ewarn "	-o feature@enabled_txg=enabled "
	ewarn "	-o feature@extensible_dataset=enabled -o feature@bookmarks=enabled"
	ewarn "	..."
	ewarn
	ewarn "GRUB2 support will be updated as soon as either the GRUB2"
	ewarn "developers do a tag or the Gentoo developers find time to backport"
	ewarn "support from GRUB2 HEAD."
}

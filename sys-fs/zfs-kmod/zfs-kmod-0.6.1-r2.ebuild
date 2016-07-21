# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

AT_M4DIR="config"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit bash-completion-r1 flag-o-matic linux-info linux-mod toolchain-funcs autotools-utils

if [ ${PV} == "9999" ] ; then
	inherit git-2
	MY_PV=9999
	EGIT_REPO_URI="git://github.com/zfsonlinux/zfs.git"
else
	inherit eutils versionator
	MY_PV=$(replace_version_separator 3 '-')
	SRC_URI="https://github.com/zfsonlinux/zfs/archive/zfs-${MY_PV}.tar.gz"
	S="${WORKDIR}/zfs-zfs-${MY_PV}"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="CDDL debug? ( GPL-2+ )"
SLOT="0"
IUSE="custom-cflags debug +rootfs"
RESTRICT="test"

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
		!UIDGID_STRICT_TYPE_CHECKS
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"

	use rootfs && \
		CONFIG_CHECK="${CONFIG_CHECK} BLK_DEV_INITRD
			DEVTMPFS"

	kernel_is ge 2 6 26 || die "Linux 2.6.26 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 3 10 || die "Linux 3.10 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	if [ ${PV} != "9999" ]
	then
		# Correctness fix for getdents
		epatch "${FILESDIR}/${P}-fix-getdents.patch"

		# Prevent possible deadlock regression
		epatch "${FILESDIR}/${P}-fix-txg_quiesce-deadlock.patch"

		# Correctness fixes for xattr
		epatch "${FILESDIR}/${P}-fix-xattr-behavior-1.patch"
		epatch "${FILESDIR}/${P}-fix-xattr-behavior-2.patch"

		# Make certain that zvols always appear
		epatch "${FILESDIR}/${P}-fix-zvol-initialization-r1.patch"

		# Linux 3.10 Compatibility
		epatch "${FILESDIR}/${PN}-0.6.1-linux-3.10-compat.patch"

		# ARC Read Panic Fix
		epatch "${FILESDIR}/${PN}-0.6.1-fix-arc-read-panic.patch"

		# Fix zfsctl_expire_snapshot deadlock
		epatch "${FILESDIR}/${PN}-0.6.1-fix-zfsctl_expire_snapshot-deadlock.patch"

		# Fix NULL pointer dereference in zfsctl_expire_snapshot
		epatch "${FILESDIR}/${PN}-0.6.1-fix-zfs_sb_teardown-NULL-pointer-deref.patch"
	fi

	# Remove GPLv2-licensed ZPIOS unless we are debugging
	use debug || sed -e 's/^subdir-m += zpios$//' -i "${S}/module/Makefile.in"

	autotools-utils_src_prepare
}

src_configure() {
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	set_arch_to_kernel
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=kernel
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodoc AUTHORS COPYRIGHT DISCLAIMER README.markdown

	# Provide /usr/src/zfs symlink for lustre
	dosym "$(basename $(echo "${ED}/usr/src/zfs-"*))/${KV_FULL}" /usr/src/zfs
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

	ewarn "This version of ZFSOnLinux includes support for features flags."
	ewarn "If you upgrade your pools to make use of feature flags, you will lose"
	ewarn "the ability to import them using older versions of ZFSOnLinux."
	ewarn "Any new pools will be created with feature flag support and will"
	ewarn "not be compatible with older versions of ZFSOnLinux. To create a new"
	ewarn "pool that is backward compatible, use zpool create -o version=28 ..."
}

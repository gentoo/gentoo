# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

if [ ${PV} == "9999" ]; then
	AUTOTOOLS_AUTORECONF="1"
	EGIT_REPO_URI="https://github.com/zfsonlinux/zfs.git"
	inherit git-r3
else
	SRC_URI="https://github.com/zfsonlinux/zfs/releases/download/zfs-${PV}/zfs-${PV}.tar.gz"
	S="${WORKDIR}/zfs-${PV}"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

inherit flag-o-matic linux-info linux-mod toolchain-funcs autotools-utils

DESCRIPTION="Linux ZFS kernel module for sys-fs/zfs"
HOMEPAGE="https://zfsonlinux.org/"

LICENSE="CDDL GPL-2+"
SLOT="0"
IUSE="custom-cflags debug +rootfs"
RESTRICT="debug? ( strip ) test"

DEPEND="
	dev-lang/perl
	virtual/awk
"

RDEPEND="${DEPEND}
	!sys-fs/zfs-fuse
	!sys-kernel/spl
"

AT_M4DIR="config"
AUTOTOOLS_IN_SOURCE_BUILD="1"

DOCS=( AUTHORS COPYRIGHT NOTICE META README.md )

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="
		!DEBUG_LOCK_ALLOC
		!GRKERNSEC_RANDSTRUCT
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
		!TRIM_UNUSED_KSYMS
		EFI_PARTITION
		KALLSYMS
		MODULES
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
		{ kernel_is le 4 17 || die "Linux 4.17 is the latest supported version."; }

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
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	set_arch_to_kernel
	local myeconfargs=(${myeconfargs}
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
	autotools-utils_src_install INSTALL_MOD_PATH="${INSTALL_MOD_PATH:-$EROOT}"
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
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic libtool linux-info udev toolchain-funcs

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples kernel_linux kernel_FreeBSD static-libs"

PDEPEND="kernel_FreeBSD? ( sys-fs/fuse4bsd )"
DEPEND="virtual/pkgconfig"
RDEPEND=">=sys-fs/fuse-common-3.3.0-r1"

pkg_setup() {
	if use kernel_linux ; then
		if kernel_is lt 2 6 9 ; then
			die "Your kernel is too old."
		fi
		CONFIG_CHECK="~FUSE_FS"
		WARNING_FUSE_FS="You need to have FUSE module built to use user-mode utils"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	local PATCHES=( "${FILESDIR}"/${PN}-2.9.3-kernel-types.patch )
	# sandbox violation with mtab writability wrt #438250
	# don't sed configure.in without eautoreconf because of maintainer mode
	sed -i 's:umount --fake:true --fake:' configure || die
	elibtoolize

	# lto not supported yet -- https://github.com/libfuse/libfuse/issues/198
	# gcc-9 with -flto leads to link failures: #663518,
	# https://gcc.gnu.org/PR91186
	filter-flags -flto*

	default
}

src_configure() {
	econf \
		INIT_D_PATH="${EPREFIX}/etc/init.d" \
		MOUNT_FUSE_PATH="${EPREFIX}/sbin" \
		UDEV_RULES_PATH="${EPREFIX}/$(get_udevdir)/rules.d" \
		$(use_enable static-libs static) \
		--disable-example
}

src_install() {
	local DOCS=( AUTHORS ChangeLog README.md README.NFS NEWS doc/how-fuse-works doc/kernel.txt )
	default

	if use examples ; then
		docinto examples
		dodoc example/*
	fi

	if use kernel_FreeBSD ; then
		insinto /usr/include/fuse
		doins include/fuse_kernel.h
	fi

	find "${ED}" -name '*.la' -delete || die

	# installed via fuse-common
	rm -r "${ED}"/{etc,$(get_udevdir)} || die

	# handled by the device manager
	rm -r "${D}"/dev || die
}

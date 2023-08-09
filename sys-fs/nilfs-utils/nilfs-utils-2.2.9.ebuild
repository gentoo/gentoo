# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info usr-ldscript

DESCRIPTION="A New Implementation of a Log-structured File System for Linux"
HOMEPAGE="http://nilfs.sourceforge.net/"
SRC_URI="http://nilfs.sourceforge.net/download/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 x86"
IUSE="static-libs"

RDEPEND="
	sys-fs/e2fsprogs
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

CONFIG_CHECK="~POSIX_MQUEUE"

src_configure() {
	# Always build static libs as nilfs_cleanerd need them
	# Bug 669804
	econf \
		--enable-static=yes \
		--libdir="${EPREFIX}"/$(get_libdir) \
		--with-libmount
}

src_install() {
	default

	if use static-libs; then
		local libdir=$(get_libdir)
		dodir /usr/${libdir}
		mv "${ED}"/${libdir}/*.a "${ED}"/usr/${libdir} || die
		gen_usr_ldscript libnilfs.so libnilfscleaner.so libnilfsgc.so
	else
		find "${ED}" -name '*.a' -delete || die
	fi

	find "${ED}" -name '*.la' -delete || die
}

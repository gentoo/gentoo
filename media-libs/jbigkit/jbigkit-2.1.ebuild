# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/jbigkit/jbigkit-2.1.ebuild,v 1.14 2014/07/26 12:29:15 ssuominen Exp $

EAPI=5

inherit eutils multilib toolchain-funcs multilib-minimal

DESCRIPTION="data compression algorithm for bi-level high-resolution images"
HOMEPAGE="http://www.cl.cam.ac.uk/~mgk25/jbigkit/"
SRC_URI="http://www.cl.cam.ac.uk/~mgk25/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2.1" # Since we install libjbig.so and libjbig85.so without version, use ${PV} like 2.1
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DOCS="ANNOUNCE CHANGES TODO libjbig/*.txt pbmtools/*.txt"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	multilib_copy_sources
	tc-export AR CC RANLIB
}

multilib_src_compile() {
	emake \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		$(multilib_is_native_abi || echo lib)

	if use static-libs; then
		cd libjbig && emake static
	fi
}

multilib_src_test() {
	LD_LIBRARY_PATH=${BUILD_DIR}/libjbig emake -j1 test
}

multilib_src_install() {
	if multilib_is_native_abi; then
		dobin pbmtools/jbgtopbm{,85} pbmtools/pbmtojbg{,85}
		doman pbmtools/jbgtopbm.1 pbmtools/pbmtojbg.1
	fi

	insinto /usr/include
	doins libjbig/*.h
	dolib libjbig/libjbig{,85}$(get_libname)
	use static-libs && dolib libjbig/libjbig{,85}.a
}

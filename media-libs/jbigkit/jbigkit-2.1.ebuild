# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal toolchain-funcs

DESCRIPTION="data compression algorithm for bi-level high-resolution images"
HOMEPAGE="http://www.cl.cam.ac.uk/~mgk25/jbigkit/"
SRC_URI="http://www.cl.cam.ac.uk/~mgk25/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}" # Since we install unversioned libraries, use ${PV} subslots.
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DOCS="ANNOUNCE CHANGES TODO libjbig/*.txt pbmtools/*.txt"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default
	multilib_copy_sources
	tc-export AR CC RANLIB
}

multilib_src_compile() {
	emake \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		$(multilib_is_native_abi || echo lib)

	use static-libs && emake -C libjbig static
}

multilib_src_test() {
	LD_LIBRARY_PATH=${BUILD_DIR}/libjbig emake -j1 test
}

multilib_src_install() {
	if multilib_is_native_abi; then
		dobin pbmtools/jbgtopbm{,85} pbmtools/pbmtojbg{,85}
		doman pbmtools/jbgtopbm.1 pbmtools/pbmtojbg.1
	fi

	doheader libjbig/*.h
	dolib.so libjbig/libjbig{,85}$(get_libname)
	use static-libs && dolib.a libjbig/libjbig{,85}.a
}

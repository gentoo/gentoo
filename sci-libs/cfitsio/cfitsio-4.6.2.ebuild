# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib fortran-2

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/10-r1"
KEYWORDS="~alpha amd64 ~hppa ~loong ~ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="bzip2 curl test tools"
RESTRICT="!test? ( test )"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
"
RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	bzip2? ( app-arch/bzip2[${MULTILIB_USEDEP}] )
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
"
# Bug #803350
DEPEND="
	${RDEPEND}
	<dev-lang/cfortran-20110621
"

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# Avoid internal cfortran
	rm cfortran.h || die
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DUSE_BZIP2=$(usex bzip2)
		-DUSE_CURL=$(usex curl)
		-DUSE_PTHREADS=ON
		# just appending CFLAGS
		-DUSE_SSE2=OFF
		-DUSE_SSSE3=OFF

		-DTESTS=$(usex test)
		-DUTILS=$(multilib_native_usex tools)
	)
	cmake_src_configure
}

multilib_src_install_all() {
	dodoc README.md docs/*.pdf

	docinto examples
	dodoc utilities/{cookbook.{c,f},testprog.c,testf77.f,speed.c,smem.c}
}

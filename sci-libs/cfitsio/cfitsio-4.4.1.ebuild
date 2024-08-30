# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib fortran-2

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/10"
KEYWORDS="~alpha amd64 ~hppa ~ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="bzip2 curl test threads tools cpu_flags_x86_sse2 cpu_flags_x86_ssse3"
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

	if ! grep -q 'CFITSIO_SONAME,10' configure.in; then
		die "Update subslot!"
	fi

	# fix libdir & sync SONAME to configure.in
	sed -e 's:lib/:${CMAKE_INSTALL_LIBDIR}/:' \
		-e "/SOVERSION/s:VERSION :VERSION ${SLOT#0/}.:" \
		-e "s:SOVERSION :SOVERSION ${SLOT#0/}.:" \
		-i CMakeLists.txt || die

	# Avoid internal cfortran
	rm cfortran.h || die
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used for .pc file
		-DLIB_SUFFIX=${libdir#lib}

		-DUSE_BZIP2=$(usex bzip2)
		-DUSE_CURL=$(usex curl)
		-DUSE_PTHREADS=$(usex threads)
		-DUSE_SSE2=$(usex cpu_flags_x86_sse2)
		-DUSE_SSSE3=$(usex cpu_flags_x86_ssse3)

		-DTESTS=$(usex test)
		-DUTILS=$(multilib_native_usex tools)
	)
	cmake_src_configure
}

multilib_src_install_all() {
	dodoc README.md docs/changes.txt docs/*.pdf

	docinto examples
	dodoc utilities/{cookbook.{c,f},testprog.c,testf77.f,speed.c,smem.c}
}

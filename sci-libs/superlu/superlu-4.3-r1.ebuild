# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils fortran-2 toolchain-funcs multilib

MY_PN=SuperLU

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( app-shells/tcsh )"

S="${WORKDIR}/${MY_PN}_${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-format-security.patch
	)

src_prepare() {
	unset VERBOSE
	sed \
		-e "s:= ar:= $(tc-getAR):g" \
		-e "s:= ranlib:= $(tc-getRANLIB):g" \
		-i make.inc || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( --with-blas="$($(tc-getPKG_CONFIG) --libs blas)" )
	autotools-utils_src_configure
	rm EXAMPLE/*itersol1 || die
}

src_test() {
	cd "${BUILD_DIR}"/TESTING
	emake -j1 \
		CC="$(tc-getCC)" \
		FORTRAN="$(tc-getFC)" \
		LOADER="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LOADOPTS="${LDFLAGS}" \
		BLASLIB="$($(tc-getPKG_CONFIG) --libs blas)" \
		SUPERLULIB="${S}/SRC/.libs/libsuperlu$(get_libname)" \
		LD_LIBRARY_PATH="${S}/SRC/.libs" \
		DYLD_LIBRARY_PATH="${S}/SRC/.libs"
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc DOC/ug.pdf && dohtml DOC/html/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r EXAMPLE FORTRAN
	fi
}

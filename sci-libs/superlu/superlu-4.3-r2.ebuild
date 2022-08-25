# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2 multilib toolchain-funcs

MY_PN=SuperLU

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="https://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
#SRC_URI="https://portal.nersc.gov/project/sparse/${PN}/${PN}_${PV}.tar.gz"
# Archive of weird franken-version which we used as 4.3 but upstream changed
# the above tarball ^. The franken-version we used seemed to have 4.1 references in it?
# bug #862597.
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}_${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}_${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( app-shells/tcsh )
"

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

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
	)

	tc-export PKG_CONFIG

	econf "${myeconfargs[@]}"

	rm EXAMPLE/*itersol1 || die
}

src_test() {
	cd TESTING || die
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
	default

	if use doc; then
		dodoc DOC/ug.pdf
		dodoc -r DOC/html/.
	fi

	if use examples; then
		docinto examples
		dodoc -r EXAMPLE FORTRAN
	fi

	find "${ED}" -name "*.a" -delete || die
}

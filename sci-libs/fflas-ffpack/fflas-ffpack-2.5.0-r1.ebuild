# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Library for dense linear algebra over word-size finite fields"
HOMEPAGE="https://linbox-team.github.io/fflas-ffpack/"
SRC_URI="https://github.com/linbox-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="openmp"

# Our autotools patch hacks in PKG_CHECK_MODULES calls.
BDEPEND="virtual/pkgconfig"
DEPEND="virtual/cblas
	virtual/blas
	virtual/lapack
	dev-libs/gmp[cxx(+)]
	=sci-libs/givaro-4.2*"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.5.0-blaslapack.patch"
	"${FILESDIR}/${PN}-2.4.3-no-test-echelon.patch"
	"${FILESDIR}/${PN}-2.4.3-fix-pc-libdir.patch"
	"${FILESDIR}/${PN}-2.5.0-no-test-fsyr2k.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG

	econf \
		--enable-precompilation \
		$(use_enable openmp)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

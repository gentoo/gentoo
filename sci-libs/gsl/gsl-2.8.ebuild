# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="https://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	https://github.com/Jamim/${PN}/commit/${P//./%2E}-cblas.patch -> ${P}-cblas.patch"

LICENSE="GPL-3+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cblas-external +deprecated static-libs"

RDEPEND="cblas-external? ( virtual/cblas:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${DISTDIR}"/${P}-cblas.patch
	"${FILESDIR}"/${PN}-2.7.1-test-tolerance.patch
	"${FILESDIR}"/${PN}-drop-broken-rng-tests.patch
)

src_prepare() {
	default

	if use deprecated; then
		sed -i -e "/GSL_DISABLE_DEPRECATED/,+2d" configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	filter-flags -ffast-math

	# with -ffp-contract=fast tests are broken beyond repair
	# which indicates that GSL might produce inaccurate values
	append-flags -ffp-contract=off

	if use cblas-external; then
		export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
		export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
	fi

	econf \
		--enable-shared \
		$(use_with cblas-external) \
		$(use_enable static-libs static)
}

src_test() {
	local MAKEOPTS="${MAKEOPTS} -j1"
	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

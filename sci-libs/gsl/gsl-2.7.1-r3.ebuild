# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="https://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-2.7-cblas.patch.bz2"

LICENSE="GPL-3+"
# Usually 0/${PV} but check
SLOT="0/27"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cblas-external +deprecated static-libs"

RDEPEND="cblas-external? ( virtual/cblas:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}"/${PN}-2.7-cblas.patch
	"${FILESDIR}"/${PN}-2.7.1-configure-clang16.patch
	"${FILESDIR}"/${PN}-2.7.1-test-tolerance.patch
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

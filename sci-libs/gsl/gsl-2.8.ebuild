# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="https://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
# Usually 0/${PV} but check
SLOT="0/28"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="cblas-external +deprecated static-libs"

RDEPEND="cblas-external? ( sci-libs/flexiblas:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.8-cblas.patch
	"${FILESDIR}"/${PN}-2.8-test_luc-tolerance.patch
)

src_prepare() {
	default

	if use deprecated; then
		sed -i -e "/GSL_DISABLE_DEPRECATED/,+2d" configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/927585
	#
	# Testsuite issue. Seems fixed in 2.8.
	filter-lto

	# 2.8 seems fine with -ffast-math
	# filter-flags -ffast-math

	# lld and mold require the part below to prevent undefined symbol errors occur with as-needed
	if tc-ld-is-lld || tc-ld-is-mold; then
		filter-ldflags "-Wl,--as-needed"
		append-ldflags "-Wl,--no-as-needed"
	fi

	if use cblas-external; then
		export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs flexiblas)"
		export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags flexiblas)"
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

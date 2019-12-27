# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="https://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/${PN}-2.3-cblas.patch.bz2"

LICENSE="GPL-3"
SLOT="0/23"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cblas-external +deprecated static-libs"

RDEPEND="cblas-external? ( virtual/cblas:= )"
DEPEND="${RDEPEND}"

PATCHES=( "${WORKDIR}"/${PN}-2.3-cblas.patch )

src_prepare() {
	# bug 349005
	[[ $(tc-getCC)$ == *gcc* ]] && \
		[[ $(tc-getCC)$ != *apple* ]] && \
		[[ $(gcc-major-version)$(gcc-minor-version) -eq 44 ]] \
		&& filter-mfpmath sse
	filter-flags -ffast-math

	default
	if use deprecated; then
		sed -i -e "/GSL_DISABLE_DEPRECATED/,+2d" configure.ac || die
	fi
	eautoreconf
}

src_configure() {
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

	find "${ED}" -name '*.la' -exec rm -f {} +
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Software package for algebraic, geometric and combinatorial problems"
HOMEPAGE="http://www.4ti2.de/"
SRC_URI="http://4ti2.de/version_${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"

DEPEND="
	sci-mathematics/glpk:0[gmp]
	dev-libs/gmp[cxx]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2-gold.patch
)

src_prepare() {
	default
	sed -e "s:^CXX.*$:CXX=$(tc-getCXX):g" \
		-i m4/glpk-check.m4 || die
	# The swig subdir is not used, so we can skip running autotools in it. #518000
	AT_NO_RECURSIVE=1 eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files --all
}

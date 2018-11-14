# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="A Library in C Facilitating Erasure Coding for Storage Applications"
HOMEPAGE="http://jerasure.org/"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/${P}.tar.gz"
S="${WORKDIR}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-libs/gf-complete"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/ $(SIMD_FLAGS)//g' src/Makefile.am Examples/Makefile.am || die
	eautoreconf
}

src_install() {
	default
	# because stupid
	insinto /usr/include
	doins include/{cauchy,galois,liberation,reed_sol}.h
	prune_libtool_files
}

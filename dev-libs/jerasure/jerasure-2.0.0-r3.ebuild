# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A Library in C Facilitating Erasure Coding for Storage Applications"
HOMEPAGE="http://jerasure.org"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/${P}.tar.gz"
S="${WORKDIR}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

DEPEND="dev-libs/gf-complete"
RDEPEND="${DEPEND}"

DOCS=( Manual.pdf README README.txt README.nd )

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-c99.patch
	"${FILESDIR}"/${PN}-2.0.0-autoconf.patch
)

src_prepare() {
	default
	sed -i -e 's/ $(SIMD_FLAGS)//g' src/Makefile.am Examples/Makefile.am || die
	eautoreconf
}

src_install() {
	default
	einstalldocs
	doheader include/{cauchy,galois,liberation,reed_sol}.h
	find "${D}" -name '*.la' -delete || die
}

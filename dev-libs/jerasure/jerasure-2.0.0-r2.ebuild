# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils

DESCRIPTION="A Library in C Facilitating Erasure Coding for Storage Applications"
HOMEPAGE="http://jerasure.org"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/${P}.tar.gz"
S="${WORKDIR}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-libs/gf-complete"
RDEPEND="${DEPEND}"

DOCS=( Manual.pdf README README.txt README.nd )

src_prepare() {
	sed -i -e 's/ $(SIMD_FLAGS)//g' src/Makefile.am Examples/Makefile.am || die
	eapply_user
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	einstalldocs
	doheader include/{cauchy,galois,liberation,reed_sol}.h
	find "${D}" -name '*.la' -delete || die
}

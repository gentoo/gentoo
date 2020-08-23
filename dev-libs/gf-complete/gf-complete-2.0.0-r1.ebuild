# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils

DESCRIPTION="A Comprehensive Open Source Library for Galois Field Arithmetic"
HOMEPAGE="http://jerasure.org"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/${P}.tar.gz"
S="${WORKDIR}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/ -O3 $(SIMD_FLAGS)//g' src/Makefile.am tools/Makefile.am test/Makefile.am examples/Makefile.am|| die
	eapply_user
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

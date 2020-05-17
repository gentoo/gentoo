# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/_p1/.pl01}

DESCRIPTION="Open-source library for reading, mastering and writing optical discs"
HOMEPAGE="https://dev.lovelyhq.com/libburnia/web/wikis/home"
SRC_URI="http://files.libburnia-project.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86"
IUSE="debug static-libs"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND=""
DEPEND="
	${RDEPEND}
"

S="${WORKDIR}/${P/_p1}"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	--disable-ldconfig-at-install \
	$(use_enable debug)
}

src_install() {
	default

	dodoc CONTRIBUTORS doc/{comments,*.txt}

	docinto cdrskin
	dodoc cdrskin/{*.txt,README}
	docinto cdrskin/html
	dodoc cdrskin/cdrskin_eng.html

	find "${D}" -name '*.la' -delete || die
}

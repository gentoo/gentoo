# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Intelligent phonetic (Zhuyin/Bopomofo) input method library"
HOMEPAGE="http://chewing.im/ https://github.com/chewing/libchewing"
SRC_URI="https://github.com/${PN/lib}/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
IUSE="static-libs test"

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	test? ( sys-libs/ncurses[unicode] )"

src_configure() {
	# libchewing.a is required for building of tests.
	econf \
		--with-sqlite3 \
		$(if use static-libs || use test; then echo --enable-static; else echo --disable-static; fi)
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
	use static-libs || find "${D}" -name "*.a" -delete || die
}

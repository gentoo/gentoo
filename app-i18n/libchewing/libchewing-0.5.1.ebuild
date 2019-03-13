# Copyright 2004-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

if [[ "${PV}" == "9999" ]]; then
	inherit autotools git-r3

	EGIT_REPO_URI="https://github.com/chewing/libchewing"
fi

DESCRIPTION="Intelligent phonetic (Zhuyin/Bopomofo) input method library"
HOMEPAGE="http://chewing.im/ https://github.com/chewing/libchewing"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/chewing/${PN}/releases/download/v${PV}/${P}.tar.bz2"
fi

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	test? ( sys-libs/ncurses[unicode] )"

src_prepare() {
	default

	if [[ "${PV}" == "9999" ]]; then
		eautoreconf
	fi
}

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

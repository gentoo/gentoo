# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools ltprune

DESCRIPTION="Library for Chinese Phonetic input method"
HOMEPAGE="http://chewing.csie.net/"
SRC_URI="https://github.com/${PN/lib}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm64 ~ppc ppc64 ~x86"
IUSE="static-libs test"
REQUIRED_USE="test? ( static-libs )"

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		dev-libs/check
		sys-libs/ncurses[unicode]
	)"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-sqlite3
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	prune_libtool_files
}

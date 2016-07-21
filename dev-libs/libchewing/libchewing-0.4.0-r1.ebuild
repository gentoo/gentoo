# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="Library for Chinese Phonetic input method"
HOMEPAGE="http://chewing.csie.net/"
SRC_URI="https://github.com/chewing/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE="static-libs test"

DEPEND="
	virtual/pkgconfig
	test? (
		sys-libs/ncurses[unicode]
		>=dev-libs/check-0.9.4
	)
	dev-db/sqlite:3
"

DOCS=( AUTHORS NEWS README.md TODO )

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-sqlite3 \
		--disable-gcov
}

src_test() {
	# test subdirectory is not enabled by default; this means that we
	# have to make it explicit.
	emake -C test check
}

src_install() {
	default
	prune_libtool_files
}

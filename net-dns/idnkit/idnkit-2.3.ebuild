# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit ltprune

DESCRIPTION="Toolkit for Internationalized Domain Names (IDN)"
HOMEPAGE="https://jprs.co.jp/idn/"
SRC_URI="${HOMEPAGE}${P}.tar.bz2"

LICENSE="JPRS"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="liteonly static-libs"
RDEPEND="
	virtual/libiconv
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"
RESTRICT="test"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable liteonly)
}

src_install() {
	default

	prune_libtool_files
}

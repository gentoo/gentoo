# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Toolkit for Internationalized Domain Names (IDN)"
HOMEPAGE="https://jprs.co.jp/idn/"
SRC_URI="https://jprs.co.jp/idn/${P}.tar.bz2"

LICENSE="JPRS"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="liteonly"
RESTRICT="test"

RDEPEND="virtual/libiconv"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"

src_configure() {
	econf $(use_enable liteonly)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

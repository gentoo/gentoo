# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Toolkit for Internationalized Domain Names (IDN)"
HOMEPAGE="https://jprs.co.jp/idn/"
SRC_URI="https://jprs.co.jp/idn/${P}.tar.bz2"

LICENSE="JPRS"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="liteonly"
RESTRICT="test"

RDEPEND="virtual/libiconv"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"

PATCHES=( "${FILESDIR}"/"${P}"-incompatible-pointers.patch )

src_configure() {
	econf $(use_enable liteonly)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

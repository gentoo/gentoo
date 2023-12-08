# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="fortune-mod-at.linux-${PV}"
DESCRIPTION="Quotes from at.linux"
HOMEPAGE="https://fortune-mod-fvl.sourceforge.net/"
SRC_URI="mirror://sourceforge/fortune-mod-fvl/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="unicode"

RDEPEND="games-misc/fortune-mod"
DEPEND="${RDEPEND}"
BDEPEND=" unicode? ( virtual/libiconv )"

src_compile() {
	# bug #322111
	if use unicode ; then
		iconv -f iso-8859-1 -t utf8 at.linux > at.linux-utf8 || die
		mv at.linux-utf8 at.linux || die
		strfile -s at.linux || die
	fi
}

src_install() {
	insinto /usr/share/fortune
	doins at.linux at.linux.dat
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A wordlist generator"
HOMEPAGE="https://sourceforge.net/projects/crunch-wordlist/"
SRC_URI="mirror://sourceforge/crunch-wordlist/crunch-wordlist/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin crunch
	doman crunch.1
	insinto /usr/share/crunch
	doins charset.lst
}

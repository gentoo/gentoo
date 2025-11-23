# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A cross-platform TCL/TK based MUD client"
HOMEPAGE="https://sourceforge.net/projects/trebuchet/"
SRC_URI="https://downloads.sourceforge.net/trebuchet/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	dev-lang/tcl
	>=dev-lang/tk-8.3.3
"

src_install() {
	emake install \
		prefix="${ED}/usr" \
		ROOT="${ED}/usr/share/${PN}"

	dosym ../share/${PN}/${PN^}.tcl /usr/bin/treb
	dodoc changes.txt README.md trebtodo.txt
}

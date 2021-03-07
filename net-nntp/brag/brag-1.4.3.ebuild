# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Brag collects and assembles multipart binary attachments from newsgroups"
HOMEPAGE="http://brag.sourceforge.net/"
SRC_URI="mirror://sourceforge/brag/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

RDEPEND="
	dev-lang/tcl:0
	app-text/uudeview"

src_compile() { :; }

src_install() {
	dobin brag
	dodoc CHANGES README
	doman brag.1
}

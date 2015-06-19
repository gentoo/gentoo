# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/brag/brag-1.4.3.ebuild,v 1.5 2015/03/20 15:41:43 jlec Exp $

EAPI=4

DESCRIPTION="Brag collects and assembles multipart binary attachments from newsgroups"
HOMEPAGE="http://brag.sourceforge.net/"
SRC_URI="mirror://sourceforge/brag/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="
	dev-lang/tcl:0
	app-text/uudeview"

src_compile() { :; }

src_install() {
	dobin brag
	dodoc CHANGES README
	doman brag.1
}

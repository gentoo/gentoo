# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ding/ding-1.7.ebuild,v 1.4 2011/12/27 21:12:39 xmw Exp $

EAPI=3

inherit eutils

DESCRIPTION="Tk based dictionary (German-English) (incl. dictionary itself)"
HOMEPAGE="http://www-user.tu-chemnitz.de/~fri/ding/"
SRC_URI="http://wftp.tu-chemnitz.de/pub/Local/urz/ding/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND=">=dev-lang/tk-8.3"

src_install() {
	dobin ding || die
	insinto /usr/share/dict
	doins de-en.txt || die
	doman ding.1 || die
	dodoc CHANGES README || die

	doicon ding.png || die
	domenu ding.desktop || die
}

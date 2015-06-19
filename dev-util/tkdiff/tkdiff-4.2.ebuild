# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tkdiff/tkdiff-4.2.ebuild,v 1.6 2012/03/18 19:39:19 armin76 Exp $

EAPI=4

DESCRIPTION="Graphical front end to the diff program"
HOMEPAGE="http://tkdiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-lang/tk"
DEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-unix"

src_install() {
	dobin tkdiff
	dodoc CHANGELOG.txt
}

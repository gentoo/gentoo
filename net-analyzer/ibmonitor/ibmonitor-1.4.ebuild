# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Interactive bandwidth monitor"
HOMEPAGE="http://ibmonitor.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~hppa ~ppc x86"
LICENSE="GPL-2"
SLOT="0"

S="${WORKDIR}/${PN}"

RDEPEND="dev-perl/TermReadKey"

src_install() {
	dobin ibmonitor
	dodoc AUTHORS ChangeLog README TODO
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Interactive bandwidth monitor"
HOMEPAGE="http://ibmonitor.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~hppa ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-perl/TermReadKey"
S=${WORKDIR}/${PN}

src_install() {
	dobin ibmonitor
	dodoc AUTHORS ChangeLog README TODO
}

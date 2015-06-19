# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/powerprefs/powerprefs-0.8.0.ebuild,v 1.6 2010/01/01 20:57:58 ssuominen Exp $

EAPI=2

DESCRIPTION="program to interface with pbbuttonsd (Powerbook/iBook) keys"
HOMEPAGE="http://pbbuttons.sf.net"
SRC_URI="mirror://sourceforge/pbbuttons/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.4:2
	>=app-laptop/pbbuttonsd-0.8.0"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}

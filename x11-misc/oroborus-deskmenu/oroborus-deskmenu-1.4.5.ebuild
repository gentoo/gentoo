# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/oroborus-deskmenu/oroborus-deskmenu-1.4.5.ebuild,v 1.3 2012/06/04 19:35:26 xmw Exp $

MY_PN=${PN/oroborus-//}

DESCRIPTION="root menu program for Oroborus"
HOMEPAGE="http://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*
	!x11-wm/oroborus-extras"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO example_rc || die
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/oroborus-keylaunch/oroborus-keylaunch-1.3.9.ebuild,v 1.3 2012/06/04 19:40:29 xmw Exp $

EAPI=4

MY_PN=${PN/oroborus-//}

DESCRIPTION="utility for binding keys in Oroborus"
HOMEPAGE="http://www.oroborus.org"
SRC_URI="mirror://debian/pool/main/k/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libX11
	!x11-wm/oroborus-extras"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	sed -e "s: -g -O2 -Wall::" \
		-e "/^install:/s/install-docs//" \
		-i Makefile.in || die
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README docs/example_rc debian/changelog
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Use your machine as a bluetooh keyboard/mouse"
HOMEPAGE="http://anselm.hoffmeister.be/computer/hidclient/"
SRC_URI="http://anselm.hoffmeister.be/computer/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-wireless/bluez"
RDEPEND="${DEPEND}
	x11-apps/xinput"

S="${WORKDIR}"

src_prepare() {
	sed -i 's#gcc#$(CC)#' Makefile
	sed -i 's#-O2#$(CFLAGS) $(LDFLAGS)#' Makefile
}

src_compile() {
	emake hidclient
}

src_install() {
	dosbin hidclient
	dodoc "${FILESDIR}"/README
}

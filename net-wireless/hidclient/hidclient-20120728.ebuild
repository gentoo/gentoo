# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit epatch

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
	epatch "${FILESDIR}"/${P}-glibc-2.30.patch
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

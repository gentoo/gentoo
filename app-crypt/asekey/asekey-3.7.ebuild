# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils udev

DESCRIPTION="ASEKey USB SIM Card Reader"
HOMEPAGE="http://www.athena-scs.com/"
SRC_URI="${HOMEPAGE}/docs/reader-drivers/${PN}-${PV/./-}-tar.bz2 -> ${P}.tar.bz2"
LICENSE="BSD LGPL-2.1"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/pcsc-lite[udev]"
RDEPEND="${RDEPEND}
	virtual/libusb:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-bundle.patch"
	sed -i -e 's/GROUP="pcscd"/ENV{PCSCD}="1"/' "92_pcscd_${PN}.rules" || die
}

src_configure() {
	econf --with-udev-rules-dir="$(get_udevdir)/rules.d"
}

src_install() {
	default
	dodoc ChangeLog README
}

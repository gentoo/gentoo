# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/rioutil/rioutil-1.5.0-r2.ebuild,v 1.4 2012/06/08 11:56:06 phajdan.jr Exp $

EAPI=4
inherit multilib eutils

DESCRIPTION="Command line tool for transfering mp3s to and from a Rio 600, 800, Rio Riot, and Nike PSA/Play"
HOMEPAGE="http://rioutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/rioutil/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buffer-overflow.patch
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" libdir="/usr/$(get_libdir)" install
	find "${ED}" -name '*.la' -exec rm -f {} +
	dodoc AUTHORS ChangeLog NEWS README TODO

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/75-rio.rules
}

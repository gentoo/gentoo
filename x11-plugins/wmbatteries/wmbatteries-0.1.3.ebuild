# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Dock app for monitoring the current battery status and CPU temperature"
HOMEPAGE="https://sourceforge.net/projects/wmbatteries"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS THANKS README example/wmbatteriesrc
}

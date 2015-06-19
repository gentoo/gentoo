# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/stalonetray/stalonetray-0.8.1.ebuild,v 1.3 2012/06/25 19:22:37 jdhore Exp $

EAPI=4

DESCRIPTION="System tray utility including support for KDE system tray icons"
HOMEPAGE="http://stalonetray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +graceful-exit kde"

RDEPEND="x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_configure() {
	econf $(use_enable debug) \
		$(use_enable graceful-exit) \
		$(use_enable kde native-kde)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README stalonetrayrc.sample TODO
	dohtml stalonetray.html
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/3ddesktop/3ddesktop-0.2.9-r1.ebuild,v 1.7 2014/07/19 19:36:03 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="OpenGL virtual desktop switching"
HOMEPAGE="http://desk3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/desk3d/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	>=media-libs/freetype-2
	media-libs/freeglut
	media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXxf86vm
"
DEPEND="
	${RDEPEND}
	x11-proto/xf86vidmodeproto
	x11-proto/xproto
"

DOCS=( AUTHORS TODO ChangeLog README README.windowmanagers )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc4.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-missing-include.patch \
		"${FILESDIR}"/${P}-gl_init.patch

	eautoreconf
}

pkg_postinst() {
	echo
	elog "This ebuild installed a configuration file called /etc/3ddesktop.conf"
	elog "The default configuration makes a screenshot of the virtual desktops"
	elog "every X seconds. This is non-optimal behavior."
	elog
	elog "To enable a more intelligent way of updating the virtual desktops,"
	elog "execute the following:"
	elog
	elog "  echo \"AutoAcquire 0\" >> /etc/3ddesktop.conf"
	elog
	elog "This will cause 3ddesktop to update the virtual desktop snapshots"
	elog "only when a 3d desktop switch is required."
}

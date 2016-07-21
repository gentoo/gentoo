# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A mouse friendly tiling window manager"
HOMEPAGE="http://www.hzog.net/index.php/Main_Page"
SRC_URI="http://www.hzog.net/pub/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-proto/xcb-proto
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/libXfixes
	x11-libs/libXdamage
	x11-proto/damageproto
	x11-proto/randrproto
	x11-libs/libXrandr
	x11-proto/xproto
	x11-proto/fixesproto
	x11-proto/compositeproto
	x11-libs/libXcomposite
	x11-proto/renderproto
	x11-libs/libXrender
	x11-libs/libXext
	x11-proto/xextproto
	x11-libs/cairo[xcb]
	x11-libs/pango
	dev-libs/glib:2"

DEPEND="${RDEPEND}"

src_install() {
	default
	# Solves file collision with dev-tcltk/tcllib, bug #574074
	ebegin "Changing references from 'page' to 'pagewm'"
	mv "${D}"usr/bin/page "${D}"usr/bin/pagewm || die "Could not rename binary!"
	sed -i -e "s:/usr/bin/page:/usr/bin/pagewm:" "${D}"usr/share/applications/page.desktop || die "Could not change .desktop file!"
	eend
}

pkg_postinst() {
	elog "page can now be launched using "pagewm". For information on why, please see"
	elog "https://bugs.gentoo.org/574074."
}

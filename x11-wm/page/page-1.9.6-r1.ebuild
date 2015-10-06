# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A mouse friendly tiling window manager"
HOMEPAGE="http://www.hzog.net/index.php/Main_Page"
SRC_URI="http://www.hzog.net/pub/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-proto/xcb-proto
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
	dev-libs/glib"

RDEPEND="!dev-tcltk/tcllib"

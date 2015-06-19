# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xgestures/xgestures-0.4.ebuild,v 1.1 2012/11/02 10:25:10 pinkbyte Exp $

EAPI=4

DESCRIPTION="A mouse gesture recognition program for X11 desktops"
HOMEPAGE="http://www.cs.bgu.ac.il/~tzachar/xgestures.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

DOCS=( AUTHORS ChangeLog NEWS README )

src_install() {
	default
	newdoc .gestures gestures
}

pkg_postinst()
{
	elog "Unpack /usr/share/doc/${PF}/gestures* and copy it to \$HOME/.gestures"
}

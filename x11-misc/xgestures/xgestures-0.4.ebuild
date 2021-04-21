# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A mouse gesture recognition program for X11 desktops"
HOMEPAGE="http://www.cs.bgu.ac.il/~tzachar/xgestures.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( AUTHORS ChangeLog NEWS README )

src_install() {
	default
	newdoc .gestures gestures
}

pkg_postinst() {
	elog "Unpack /usr/share/doc/${PF}/gestures* and copy it to \$HOME/.gestures"
}

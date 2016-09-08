# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="An application that translates joystick events to mouse events"
HOMEPAGE="https://sourceforge.net/projects/joymouse-linux"
SRC_URI="mirror://sourceforge/joymouse-linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE=""

DEPEND="x11-proto/xextproto
	x11-proto/inputproto"
RDEPEND="x11-libs/libX11
	x11-libs/libXtst"

src_prepare() {
	sed -i 's/printf(message/fputs(message, stdout/g' src/joymouse.c || die
}

src_install() {
	default
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="An application that translates joystick events to mouse events"
HOMEPAGE="https://sourceforge.net/projects/joymouse-linux"
SRC_URI="mirror://sourceforge/joymouse-linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	sed -i 's/printf(message/fputs(message, stdout/g' src/joymouse.c || die
}

src_install() {
	default
}

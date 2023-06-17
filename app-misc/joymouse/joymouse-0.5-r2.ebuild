# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An application that translates joystick events to mouse events"
HOMEPAGE="https://sourceforge.net/projects/joymouse-linux"
SRC_URI="mirror://sourceforge/joymouse-linux/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed -i 's/printf(message/fputs(message, stdout/g' src/joymouse.c || die

	# Clang 16, bug #900473
	eautoreconf
}

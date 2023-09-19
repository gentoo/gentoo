# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An application that translates joystick events to keyboard events"
HOMEPAGE="https://sourceforge.net/projects/joy2key"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-apps/xwininfo
	)"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )"

src_configure() {
	econf $(use_enable X)
}

src_install() {
	default
	dodoc joy2keyrc.sample rawscancodes
}

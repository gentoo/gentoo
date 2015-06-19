# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/qjoypad/qjoypad-4.1.0.ebuild,v 1.11 2014/11/28 19:41:28 mr_bones_ Exp $

EAPI=5
inherit eutils qt4-r2

DESCRIPTION="Translate gamepad/joystick input into key strokes/mouse actions in X"
HOMEPAGE="http://qjoypad.sourceforge.net/"
SRC_URI="mirror://sourceforge/qjoypad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	x11-libs/libXtst
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto"

S=${WORKDIR}/${P}/src

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlink.patch
	# fixup the icon tray support (bug #436426)
	sed -i \
		-e '/^icons.extra/d' \
		-e '/^icons/s:/qjoypad::' \
		-e 's/icon24.png/qjoypad4-24x24.png/' \
		-e 's/icon64.png/qjoypad4-64x64.png/' \
		qjoypad.pro || die
}

src_configure() {
	eqmake4 qjoypad.pro PREFIX=/usr DEVDIR=/dev/input
}

src_install() {
	local i
	dobin qjoypad
	dodoc ../README.txt
	cd ../icons
	for i in *; do
		newicon ${i} ${i/gamepad/qjoypad}
	done
	make_desktop_entry qjoypad QJoypad ${PN}4-64x64
}

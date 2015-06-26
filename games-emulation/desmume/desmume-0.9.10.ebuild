# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/desmume/desmume-0.9.10.ebuild,v 1.3 2015/06/26 08:33:34 ago Exp $

EAPI="5"

inherit games

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="http://desmume.org/"
SRC_URI="mirror://sourceforge/desmume/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8.0:2
	gnome-base/libglade
	x11-libs/gtkglext
	virtual/opengl
	sys-libs/zlib
	dev-libs/zziplib
	media-libs/libsdl[joystick]
	x11-libs/agg"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/desmume-fix-function-type.patch"
}

src_configure() {
	egamesconf --datadir=/usr/share
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README README.LIN
	prepgamesdirs
}

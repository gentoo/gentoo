# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtime/wmtime-1.2.ebuild,v 1.1 2015/01/13 12:28:22 voyageur Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="applet which displays the date and time in a dockable tile"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmtime"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/dockapps

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install () {
	emake DESTDIR="${D}" PREFIX=/usr install

	dodoc BUGS CHANGES HINTS README TODO
}

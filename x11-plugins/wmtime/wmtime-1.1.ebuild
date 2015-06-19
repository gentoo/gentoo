# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtime/wmtime-1.1.ebuild,v 1.2 2014/11/05 13:13:24 voyageur Exp $

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
	x11-proto/xproto
	x11-proto/xextproto"

S=${WORKDIR}/dockapps/${PN}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin wmtime
	doman wmtime.1

	cd ..
	dodoc BUGS CHANGES HINTS README TODO
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="CD player applet for WindowMaker"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmcdplay"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/dockapps

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ARTWORK README
	domenu "${FILESDIR}"/${PN}.desktop
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="dockapp that displays memory and swap space usage"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmmemload"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libICE
	x11-libs/libXt"

S=${WORKDIR}/dockapps

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog THANKS
}

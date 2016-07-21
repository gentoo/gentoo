# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="dockapp that displays memory and swap space usage"
HOMEPAGE="http://www.markstaggs.net/wmmemload"
SRC_URI="http://markstaggs.net/${PN}-download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libICE
	x11-libs/libXt"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-kernel-3-support.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog THANKS
}

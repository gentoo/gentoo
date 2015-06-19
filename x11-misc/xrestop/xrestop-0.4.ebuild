# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xrestop/xrestop-0.4.ebuild,v 1.12 2015/01/03 10:45:55 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="'Top' like statistics of X11 client's server side resource usage"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xrestop"
SRC_URI="http://projects.o-hand.com/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86 ~x86-fbsd"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-proto/xproto
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

DOCS=( AUTHORS ChangeLog NEWS README )

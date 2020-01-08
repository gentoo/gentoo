# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="'Top' like statistics of X11 client's server side resource usage"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xrestop"
SRC_URI="http://projects.o-hand.com/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ~ppc64 sparc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

DOCS=( AUTHORS ChangeLog NEWS README )

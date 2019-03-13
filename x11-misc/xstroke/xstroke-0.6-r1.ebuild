# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools eutils

DESCRIPTION="Gesture/Handwriting recognition engine for X"
# Dead upstream?
#HOMEPAGE="http://www.xstroke.org/"
HOMEPAGE="http://freshmeat.net/projects/xstroke/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ~mips ppc sparc x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	x11-base/xorg-proto
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-sigsegv_sprintf.patch \
		"${FILESDIR}"/${P}-underlinking.patch
	eautoreconf
}

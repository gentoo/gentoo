# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xstroke/xstroke-0.6-r1.ebuild,v 1.8 2012/09/12 01:51:34 jer Exp $

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
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-sigsegv_sprintf.patch \
		"${FILESDIR}"/${P}-underlinking.patch
	eautoreconf
}

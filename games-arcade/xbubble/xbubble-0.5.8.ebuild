# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="a Puzzle Bobble clone similar to Frozen-Bubble"
HOMEPAGE="http://www.nongnu.org/xbubble/"
SRC_URI="http://www.ibiblio.org/pub/mirrors/gnu/ftp/savannah/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="nls"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	media-libs/libpng:0
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
DOCS=( AUTHORS ChangeLog NEWS NetworkProtocol README TODO )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-xpaths.patch \
		"${FILESDIR}"/${P}-locale.patch \
		"${FILESDIR}"/${P}-libpng14.patch \
		"${FILESDIR}"/${P}-png15.patch
	sed -i \
		-e '/^AM_CFLAGS/d' \
		src/Makefile.in || die
	sed -i \
		-e '/^localedir/s:=.*:=/usr/share/locale:' \
		configure po/Makefile.in.in || die
}

src_configure() {
	egamesconf $(use_enable nls)
}

src_install() {
	default
	newicon data/themes/fancy/Bubble_black_DEAD_01.png ${PN}.png
	make_desktop_entry ${PN} XBubble
	prepgamesdirs
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools

DESCRIPTION="A Go-frontend"
HOMEPAGE="http://cgoban1.sourceforge.net/"
SRC_URI="mirror://sourceforge/cgoban1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	|| (
		media-gfx/imagemagick
		media-gfx/graphicsmagick[imagemagick]
	)
	x11-libs/libX11
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	# ${P}-cflags.patch patches configure.ac, not .in:
	mv configure.{in,ac} || die

	default

	cp cgoban_icon.png ${PN}.png || die
	eautoreconf
}

src_install() {
	default
	doicon ${PN}.png
	make_desktop_entry cgoban Cgoban
}

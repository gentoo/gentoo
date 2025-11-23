# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Dockable keyboard layout switcher for Window Maker"
HOMEPAGE="http://wmalms.tripod.com/#WMXKB"
SRC_URI="http://wmalms.tripod.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( CHANGES README )
HTML_DOCS=( doc/manual{,_body,_title}.html )

src_prepare() {
	default
	sed -i -e 's:$(LD) -o:$(CC) $(LDFLAGS) -o:' Makefile.in || die #336528
	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin wmxkb
	insinto /usr/share/pixmaps/wmxkb
	doins pixmaps/*.xpm
	einstalldocs
}

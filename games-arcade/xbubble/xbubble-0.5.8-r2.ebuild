# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="A Puzzle Bobble clone similar to Frozen-Bubble"
HOMEPAGE="http://www.nongnu.org/xbubble/"
SRC_URI="http://www.ibiblio.org/pub/mirrors/gnu/ftp/savannah/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	media-libs/libpng:=
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog NEWS NetworkProtocol README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-xpaths.patch
	"${FILESDIR}"/${P}-locale.patch
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-png15.patch
)

src_prepare() {
	default

	sed -i \
		-e '/^AM_CFLAGS/d' \
		src/Makefile.in || die
	sed -i \
		-e '/^localedir/s:=.*:=/usr/share/locale:' \
		configure po/Makefile.in.in || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {

	default
	newicon data/themes/fancy/Bubble_black_DEAD_01.png ${PN}.png
	make_desktop_entry ${PN} XBubble
}

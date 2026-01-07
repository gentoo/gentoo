# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="A free Worms clone"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/${PN}-11.04"

LICENSE="
	GPL-2+
	|| ( Apache-2.0 GPL-3 )
	UbuntuFontLicense-1.0
	vlgothic
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug unicode"

RDEPEND="
	dev-libs/libxml2:=
	media-libs/libpng:=
	media-libs/libsdl[joystick,video,X]
	media-libs/sdl-gfx:=
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	net-misc/curl
	virtual/libintl
	x11-libs/libX11
	unicode? ( dev-libs/fribidi )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-action.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-stat.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
	"${FILESDIR}"/${P}-respect-AR.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--enable-nls \
		$(use_enable debug) \
		$(use_enable unicode fribidi)
}

src_install() {
	default

	doicon data/icon/warmux.svg
	make_desktop_entry warmux Warmux
}

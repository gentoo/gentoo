# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library of code shared between tuxmath and tuxtype"
HOMEPAGE="https://github.com/tux4kids/t4kcommon"
SRC_URI="https://github.com/tux4kids/t4kcommon/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="svg"

RDEPEND="
	dev-libs/libxml2:2
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/sdl-pango
	svg? (
		gnome-base/librsvg:2
		media-libs/libpng:0
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}"
# need sys-devel/gettext for AM_ICONV in iconv.m4
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/t4kcommon-upstream-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-libpng.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ICONV_CONST.patch
)

src_prepare() {
	default
	rm m4/iconv.m4 || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(usex svg "" --without-rsvg)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

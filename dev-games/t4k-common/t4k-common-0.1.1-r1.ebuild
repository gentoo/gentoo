# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library of code shared between tuxmath and tuxtype"
HOMEPAGE="https://github.com/tux4kids/t4kcommon"
SRC_URI="https://github.com/tux4kids/t4kcommon/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/t4kcommon-upstream-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="svg"

RDEPEND="
	dev-libs/libxml2:2
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-pango
	svg? (
		gnome-base/librsvg:2
		media-libs/libpng:=
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}"
# need sys-devel/gettext for AM_ICONV added to configure.ac
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-libpng.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ICONV_CONST.patch
	"${FILESDIR}"/${P}-fix-declaration.patch
	"${FILESDIR}"/${P}-missing-text.patch
	"${FILESDIR}"/${P}-svg-libxml2.patch
)

src_prepare() {
	default

	rm m4/iconv.m4 || die
	eautoreconf
}

src_configure() {
	# note: sdlpango<->sdlttf breaks ABI, prefer default pango
	local econfargs=(
		$(usex svg '' --without-rsvg)
		--disable-static
	)
	econf "${econfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
